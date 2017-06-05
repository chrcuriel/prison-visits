module DateHelper
  def format_date_of_birth(date)
    I18n.l(date.to_date, format: :date_of_birth)
  end

  def format_date_without_year(date)
    I18n.l(date.to_date, format: :date_without_year)
  end

  def format_time_12hr(time)
    I18n.l(time, format: :twelve_hour)
  end

  def format_time_24hr(time)
    I18n.l(time, format: :twenty_four_hour)
  end

  def format_slot_begin_time_for_public(slot)
    I18n.t(
      'formats.slot.public.begin_only',
      date: format_date_without_year(slot.begin_at.to_date),
      time: format_time_12hr(slot.begin_at)
    )
  end

  def format_slot_for_public(slot)
    I18n.t(
      'formats.slot.public.full',
      date: format_date_without_year(slot.begin_at.to_date),
      time: format_time_12hr(slot.begin_at),
      duration: format_duration(slot.duration)
    )
  end

  def format_slot_for_staff(slot)
    I18n.t(
      'formats.slot.staff',
      date: format_date_without_year(slot.begin_at.to_date),
      begin: format_time_24hr(slot.begin_at),
      end: format_time_24hr(slot.end_at)
    )
  end

  def minimum_date_of_birth
    AgeValidator::MAX_AGE.years.ago.beginning_of_year.to_date
  end

  def maximum_date_of_birth
    Time.zone.today.end_of_year
  end

private

  def format_duration(secs)
    hours = secs.to_i / 3600
    minutes = (secs.to_i / 60) % 60

    parts = []
    parts << I18n.t('formats.duration.hours', count: hours) if hours > 0
    parts << I18n.t('formats.duration.minutes', count: minutes) if minutes > 0

    parts.join(I18n.t('formats.duration.glue'))
  end
end
