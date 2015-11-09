ConcreteSlot = Struct.new(
  :year, :month, :day, :begin_hour, :begin_minute, :end_hour, :end_minute
) do
  def self.parse(str)
    m = str.match(%r{
      \A (\d\d\d\d) - (\d\d) - (\d\d) T (\d\d) : (\d\d) / (\d\d) : (\d\d) \z
    }x)
    if m
      new(*m[1, 7].map { |s| s.to_i(10) })
    else
      fail ArgumentError, %{cannot parse "#{str}"}
    end
  end

  def iso8601
    '%04d-%02d-%02dT%02d:%02d/%02d:%02d' % [
      year, month, day, begin_hour, begin_minute, end_hour, end_minute
    ]
  end

  # We are explicitly parsing these as UTC, but this Rubocop cop isn't clever
  # enough to realise. We use UTC because we don't actually care about time
  # zone offsets: booking times are always given in terms of wall time, and
  # we only use Time to give us a convenient way to perform maths and to
  # format dates and times for output.
  #
  # rubocop:disable Rails/TimeZone
  def begin_at
    Time.new(year, month, day, begin_hour, begin_minute, 0, '+00:00')
  end

  def end_at
    Time.new(year, month, day, end_hour, end_minute, 0, '+00:00')
  end
  # rubocop:enable Rails/TimeZone

  def duration
    (end_at - begin_at).to_i
  end
end