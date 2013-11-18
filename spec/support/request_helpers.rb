module Requests
  module Helpers
    def json
      @json ||= JSON.parse(response.body)
    end

    def sign_in_as_therapist
      @user ||= FactoryGirl.create(:user_with_therapist)
      post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @user.password
    end
  end
end
