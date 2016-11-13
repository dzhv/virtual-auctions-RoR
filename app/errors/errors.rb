# Error messages used in the system
class Errors
  # General exception
  class Error < RuntimeError
  end

  # Insufficient bid amount error
  class InsufficientBidError < Error
  end

  # Insufficient funds error
  class InsufficientFundsError < Error
  end

  # # Not found exception
  # class NotFoundError < Error
  # end

  # # Wrong credentials entered exception
  # class WrongCredentialsError < Error
  # end

  # # Exception for unauthorized actions
  # class UnauthorizedError < Error
  # end

  # # Exception for not allowed actions
  # class NotAllowedError < Error
  # end
end
