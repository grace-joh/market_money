class ErrorSerializer
  def self.not_found(error)
    {
      "errors": [
        {
          "detail": error
        }
      ]
    }
  end
end
