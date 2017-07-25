def stub_facebook
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    privider: 'facebook',
    uid: '12345',
    info:{
      email: 'ward.colleen.a@gmail.com',
      first_name: 'Colleen',
      last_name: 'Ward',
      image: "http://graph.facebook.com/v2.6/10100295829467675/picture",
      verified: true
    },
    credentials: {
      token: ENV['FACEBOOK_USER_TOKEN'],
      expires_at: 1500312576,
      expires: true
    }
    })

end

def stub_google
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
    provider: 'google',
    uid: "108878560139118396968",
    info: {
      name: "Beth K",
      email: "bethknight1234@gmail.com",
      first_name: "Beth",
      last_name: "K",
      image: "https://lh6.googleusercontent.com/-LLQghVrGuz8/AAAAAAAAAAI/AAAAAAAAAeY/NvLBwfaHEJA/s50-c/photo.jpg"
    },
    credentials: {
      token: "ya29.GltOBEMN4S-ke5aQEWsZTWx2VN4gW0sZ3TzpE4AcYd6662RG0e2DBGl-LS9grUTCBwdOR7IEfLiwoAVLsZqTDxVstAS1NDpvmZ33DQ40hNllWSzAIja7b6ZlYlQ-",
      refresh_token: "1/V-yVGxQuMFwZrafORBiXVvBNn3bhvocQ7lliukW9FaQ",
      expires_at: 1495138014,
      expires: true
    }
  })
end

def per_month_rev(mon)
  "$#{(9.99*mon).round(2)}"
end


def find_city_revenue(cities, limit = 10, month = "", year = "")
  if (month == "") && (year == "")
    revenue = cities.map do |city|
      Property.joins(:reservations)
        .where(city: city)
        .sum('reservations.total_price')
        .limit(limit)
    end
  elsif (month == "")
    revenue = cities.map do |city|
      Property.joins(:reservations)
        .where(city: city)
        .sum('reservations.total_price')
    end
  elsif (year == "")
    revenue = cities.map do |city|
      Property.joins(:reservations)
        .where(city: city)
        .sum('reservations.total_price')
    end
  else
    out = cities.reduce([]) do |t, city|
      revenue = Property.joins(:reservations)
        .where(city: city, reservations: {start_date: "#{year}-#{month}-01"})
        .sum('reservations.total_price')
      t << [city, revenue]; t
    end
    out.sort{|a,b| (a[1] <=> b[1]) == 0 ? (b[0] <=> a[0]) : (a[1] <=> b[1]) }.reverse.take(limit)
  end
end
