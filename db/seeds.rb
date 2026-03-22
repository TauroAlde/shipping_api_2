[
  { carrier: "dhl", deliveries: 95, failures: 5, avg_days: 2.0 },
  { carrier: "fedex", deliveries: 80, failures: 20, avg_days: 3.5 },
  { carrier: "ups", deliveries: 60, failures: 40, avg_days: 4.0 }
].each do |stat|
  ShipmentStat.find_or_create_by!(carrier: stat[:carrier]) do |s|
    s.deliveries = stat[:deliveries]
    s.failures = stat[:failures]
    s.avg_days = stat[:avg_days]
  end
end

User.find_or_create_by!(email: "amed157@hotmail.com") do |u|
  u.password = "123456"
end
