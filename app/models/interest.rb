class Interest < ApplicationRecord
  belongs_to :user

  scope :by_format, -> (format) do
    where('lower(format) LIKE ?', "%#{format.downcase}%")
  end

  scope :by_local, -> (local) do
    where('lower(local) LIKE ?', "%#{local.downcase}%")
  end
end
