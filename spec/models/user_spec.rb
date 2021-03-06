require 'spec_helper'

describe User do
	before {@user = User.new(name: "Example User", email: "user@example.com",
							 password: "foobar", password_confirmation: "foobar")}
	subject{ @user }
	it {should respond_to(:name)}
	it {should respond_to(:email)}
	it {should respond_to(:password_digest)}
	it {should respond_to(:password)}
	it {should respond_to(:password_confirmation)} 
  	it { should respond_to(:remember_token) }
  	it { should respond_to(:authenticate) }
  	it { should respond_to(:admin) }
	it { should respond_to(:microposts) }
	it { should respond_to(:feed) }

	it {should be_valid}

	describe "wahen name is not present" do
		before{@user.name = " "}
		it {should_not be_valid}
	end

	describe "when email is not presence" do
		before{@user.email= " "}
		it {should_not be_valid}
	end

	describe "when name to long" do
		before {@user.name = "a" * 51}
		it {should_not be_valid}
	end

	describe "when email format is invalid" do
		it "should be valid " do
			emails = %w[user@foo,com example.user@foo. user_at_foo.org]
			emails.each do |invalid_email|
				@user.email = invalid_email
				@user.should_not be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "shoud be valid" do
			emails = %w[user@foo.com USER_US@b.a.r.org first.name@email.jp a+b@baz.cn]
			emails.each do |valid_email|
				@user.email = valid_email
				@user.should be_valid
			end
		end
	end

	describe "when email is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end
		it {should_not be_valid}
	end

	describe "when password in't presence" do
		before {@user.password = @user.password_confirmation = " "}
		it {should_not be_valid}
	end

	describe "when password doesn't match confirmation" do
		before {@user.password_confirmation = "mismatch"}
		it {should_not be_valid}
	end


	describe "when password confirmation is nil" do
		before {@user.password_confirmation = nil}
		it {should_not be_valid}
	end

	describe "when password is too short" do
		before{@user.password_confirmation = "a" * 5}
		it{should_not be_valid}
	end

	describe "return value of authentication method" do
		before {@user.save}
		let(:found_user) {User.find_by_email(@user.email)}

		describe "with valid pasword" do
			it {should == found_user.authenticate(@user.password)}
		end
		describe "with invalid password" do
			let(:user_with_invalid_password) {found_user.authenticate("invalid")}
			it {should_not == user_with_invalid_password}
			specify {user_with_invalid_password.should be_false}
		end
	end

	# exercise 1
	describe "email address with mixed case" do
		let(:mixed_case_email) {"Foo@ExaAMPle.CoM"}
		it "it should be saved as all lower-case" do
			@user.email = mixed_case_email
			@user.save
			expect(@user.reload.email).to eq mixed_case_email.downcase
		end
	end
	#exercise 3
	describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "micropost associations" do

    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end
    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end
  end
end
