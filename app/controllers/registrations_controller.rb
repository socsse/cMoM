class RegistrationsController < Devise::RegistrationsController

  def initialize
    @test_count = 0
  end

  def edit
    @test_count = Time.now
    logger.info "Test Count = #{@test_count}"
    current_user.errors.clear
  end

  def update
    @test_count = Time.now
    logger.info "Test Count = #{@test_count}"
    super
  end

end
