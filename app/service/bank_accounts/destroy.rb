module BankAccounts
  class Destroy
    include Serviceable

    validate :validate_bank_account!

    def initialize(user)
      @user = user
    end

    def call
      valid?
      set_bank_account
      destroy_bank_account_in_stripe!
      destroy_bank_account_for_user
    end

    attr_reader :user, :bank_account_id

    def validate_bank_account!
      fail! "the user don't have any bank account" unless user.bank_account.present?
    end

    def set_bank_account
      @bank_account_id = user.bank_account.account_id
    end

    def destroy_bank_account_in_stripe!
      begin
        account = Stripe::Account.retrieve(bank_account_id)
        account.delete if account.present?
      rescue Stripe::InvalidRequestError, Stripe::CardError => e
        fail! "Associate bank account with Stripe error, #{e.message}."
      end
    end

    def destroy_bank_account_for_user
      return true if user.bank_account.destroy
      return false
    end
  end
end
