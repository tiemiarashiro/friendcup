class Interest < ApplicationRecord
  belongs_to :user

  scope :by_format, -> (format) do
    where('format LIKE ?', "%#{format}%")
  end

  scope :by_local, -> (local) do
    where('local LIKE ?', "%#{local}%")
  end
end
