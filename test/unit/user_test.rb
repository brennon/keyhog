require 'test_helper'
require 'benchmark'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = FactoryGirl.create(:user)
  end

  # Required attributes
  should validate_presence_of :username
  should validate_presence_of :email
  should validate_presence_of :first_name
  should validate_presence_of :last_name
  should validate_presence_of :password

  # Unique attributes
  should validate_uniqueness_of :username
  should validate_uniqueness_of :email

  # Other validations
  should ensure_length_of(:username).is_at_least(6).is_at_most(24)
  should allow_value('bobbo@example.com').for(:email)
  should allow_value('bob@example.au').for(:email)
  should allow_value('bob@example.co.uk').for(:email)
  should allow_value('bob.thomas@example.com').for(:email)
  should_not allow_value('bob@example').for(:email)
  should_not allow_value('bob').for(:email)
  should_not allow_value('bob@example com').for(:email)

  # Password requirements:
  #   - 2 lowercase letters
  #   - 2 uppercase letters
  #   - 2 numbers
  #   - 2 symbols
  should allow_value('aB1!cD2@').for(:password)

  # Disallow mass assignments
  should_not allow_mass_assignment_of(:hashed_password)
  should_not allow_mass_assignment_of(:salt)

  test "generates password salts" do
    assert_respond_to User, :new_salt
  end

  test "should return a string as a salt" do
    assert_kind_of String, User.new_salt
  end

  test "should return at least a 256-bit string as a salt" do
    assert User.new_salt.bytesize >= 32
  end

  test "should hash passwords" do
    assert_respond_to @user, :hash_password
  end

  test "should return a string as a hashed password" do
    assert_kind_of Hash, @user.hash_password(password: 'password')
  end

  test "should return the salt in the hashed password hash" do
    assert_not_nil @user.hash_password(password: 'password')[:salt]
  end

  test "should return the hashed password in the hashed password hash" do
    assert_not_nil @user.hash_password(password: 'password')[:hashed_password]
  end

  test "should require a password to hash" do
    assert_raise RuntimeError do
      @user.password = nil
      @user.hash_password
    end
  end

  test "should return a 512-bit hashed password" do
    assert_equal @user.hash_password('password')[:hashed_password].bytesize, 90
  end

  test "should return different hashed passwords for the same input" do
    password_a = @user.hash_password('password')[:hashed_password]
    password_b = @user.hash_password('password')[:hashed_password]
    assert_not_equal password_a, password_b
  end

  test "should return different salts for the same input" do
    salt_a = @user.hash_password('password')[:salt]
    salt_b = @user.hash_password('password')[:salt]
    assert_not_equal salt_a, salt_b
  end

  test "should return an ASCII string" do
    assert_equal 'US-ASCII', 
      @user.hash_password('password')[:hashed_password].encoding.name
  end

  test "should hash password when User is created" do
    User.any_instance.expects(:update_hashed_password)
    u = FactoryGirl.create(:user)
  end

  test "should have a constant-time slow equality check" do
    assert_respond_to @user, :slow_equals
  end

  test "slow equals should return true if parameters match" do
    assert @user.slow_equals("one", "one")
  end

  test "slow equals should return false if parameters do not match" do
    assert !@user.slow_equals("one", "two")
  end

  test "slow equals raises an error if parameters are not Strings" do
    assert_raise RuntimeError do
      @user.slow_equals(1,1)
    end
  end

  test "slow equals should take longer than a regular compare" do
    regular = Benchmark.realtime {
      "a"*511+"b" == "b" + "a"*511
    }

    slow = Benchmark.realtime {
      @user.slow_equals("a"*511+"b", "b"+"a"*511)
    }

    assert slow > regular
  end

  test "slow equals returns false for strings of differing lengths" do
    assert !@user.slow_equals("a"*4, "a"*5)
  end

  test "hashed password should be stored" do
    @user.save
    assert_not_nil @user.hashed_password
  end

  test "salt should be stored" do
    @user.save
    assert_not_nil @user.salt
  end

  test "validate_password should return true for the correct password" do
    @user.save
    assert @user.validate_password(@user.password)
  end

  test "validate_password should return false with an incorrect password" do
    @user.save
    assert !@user.validate_password("INVALID")
  end

  test "should respond to validate_password" do
    assert_respond_to @user, :validate_password
  end

  test "validate_password raises an error with a nil parameter" do
    assert_raise RuntimeError do
      @user.validate_password nil
    end
  end

  test "validate_password uses slow_equals" do
    @user.save
    @user.expects(:slow_equals)
    @user.validate_password(@user.password)
  end
end
