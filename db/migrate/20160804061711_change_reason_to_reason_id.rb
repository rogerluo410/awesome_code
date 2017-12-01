class ChangeReasonToReasonId < ActiveRecord::Migration[5.0]
  def change
    rename_column(:surveys, :reason, :reason_id)
    change_column(:surveys, :reason_id, 'integer USING CAST(reason_id AS integer)')
  end

end
