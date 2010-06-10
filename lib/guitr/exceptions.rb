##
# Raised to indicate that a system exit should occur with the specified
# exit_code

class Guitr::SystemExitException < SystemExit
  attr_accessor :exit_code

  def initialize(exit_code)
    @exit_code = exit_code

    super "Exiting Guitr with exit_code #{exit_code}"
  end

end