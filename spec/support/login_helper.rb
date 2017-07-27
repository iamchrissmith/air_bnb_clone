module LoginHelper

  def login(user)
    visit new_user_session_path
    fill_in "Username or email", with: user.email
    fill_in "Password", with: "password"
    click_on "Log in"
  end

  def logout
    click_link 'Log Out'
  end

end
