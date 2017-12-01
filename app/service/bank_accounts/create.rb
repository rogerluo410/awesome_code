module BankAccounts
  class Create
    include Serviceable

    validate :validate_params!

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      valid?
      set_country_code
      set_bank_account
      create_bank_account_in_stripe!
      create_bank_account_for_user
      user.bank_account
    end

    attr_reader :params, :country_code, :user, :bank_account, :stripe_bank_account

    def validate_params!
      if params[:number].blank?
        fail! "Bank account number not be blank."
      end
      if params[:country].blank?
        fail! "Bank account country not be blank."
      end
      if params[:currency].blank?
        fail! "Bank account currency not be blank."
      end
    end

    def set_country_code
      @country_code = Carmen::Country.named(params[:country]).code
    end

    def set_bank_account
      @bank_account = {
        account_number: params[:number],
        country: country_code,
        currency: params[:currency].downcase,
        #STRIPE TEST BANK AU routing number
        :routing_number => "110000"
      }
    end

    def create_bank_account_in_stripe!
      begin
        token = Stripe::Token.create(:bank_account => bank_account)
        account = Stripe::Account.create( :managed => true, :country => country_code, external_account: token.id)
        @stripe_bank_account = {
            account_id: account.id,
            country: token.bank_account[:country],
            currency: token.bank_account[:currency],
            last4: token.bank_account[:last4],
            bank_name: token.bank_account[:bank_name],
            account_holder_name: token.bank_account[:account_holder_name],
            account_holder_type: token.bank_account[:account_holder_type],
            routing_number: token.bank_account[:routing_number],
        }
      rescue Stripe::InvalidRequestError, Stripe::CardError => e
        fail! "Associate bank account with Stripe error, #{e.message}."
      end
    end

    def create_bank_account_for_user
      stripe_bank_account[:id] = user.bank_account.id if user.bank_account.present?
      user.update(bank_account_attributes: stripe_bank_account)
    end
  end
end
