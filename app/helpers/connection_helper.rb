module ConnectionHelper  
  def conn
    @conn ||= if ENV['DATABASE_URL'].present?
      uri = URI.parse(ENV['DATABASE_URL'])
      PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
    else
      PG.connect(dbname: 'postgres')
    end
  end
end