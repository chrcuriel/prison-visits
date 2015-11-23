class VisitorMailer < ActionMailer::Base
  include LogoAttachment
  include NoReply
  include DateHelper
  add_template_helper DateHelper

  layout 'email'

  def request_acknowledged(visit)
    @visit = visit

    SpamAndBounceResets.new(@visit).perform_resets

    mail(
      reply_to: visit.prison_email_address,
      to: visit.recipient,
      subject: default_i18n_subject(
        receipt_date: format_date_of_visit(visit.first_date)
      )
    )
  end

  def booked(visit)
    @visit = visit

    mail(
      reply_to: visit.prison_email_address,
      to: visit.recipient,
      subject: default_i18n_subject(
        date: format_date_of_visit(visit.date)
      )
    )
  end

  def rejected(visit)
    @visit = visit

    mail(
      reply_to: visit.prison_email_address,
      to: visit.recipient,
      subject: default_i18n_subject(
        date: format_date_of_visit(visit.first_date)
      )
    )
  end
end
