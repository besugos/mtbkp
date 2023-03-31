FactoryBot.define do
  factory :distance_service_historic do
    lat_origin { "MyString" }
    lng_origin { "MyString" }
    lat_destination { "MyString" }
    lng_destination { "MyString" }
    destination_address { "MyText" }
    origin_address { "MyText" }
    origin_address { "MyText" }
    distance_text { "MyText" }
    duration_text { "MyText" }
    distance_value { "9.99" }
    duration_value { "9.99" }
  end
end
