# Responsible for fetching constraints, potentially via API calls, and
# returning constraint objects
class BookingConstraints
  def initialize(prison_id: nil)
    @prison_id = prison_id
  end

  def on_visitors
    VisitorConstraints.new(
      adult_age: 18 # TODO: This varies for some prisons
    )
  end

  def on_slots
    fail 'No prison' unless @prison_id
    slots = PrisonVisits::Api.instance.get_slots(@prison_id)
    SlotConstraints.new(slots)
  end

  class VisitorConstraints
    MAX_ADULTS = 3
    MIN_ADULTS = 1

    def initialize(adult_age: 18)
      @adult_age = adult_age
      @max_visitors = 6
    end

    attr_reader :adult_age, :max_visitors

    def validate_visitor_ages_on(target, field, ages)
      adults, _children = ages.partition { |a| adult?(a) }.map(&:length)
      if adults > MAX_ADULTS
        target.errors.add field, :too_many_adults,
          max: MAX_ADULTS,
          age: adult_age
      elsif adults < MIN_ADULTS
        target.errors.add field, :too_few_adults,
          min: MIN_ADULTS,
          age: adult_age
      end
    end

  private

    def adult?(age)
      age >= adult_age
    end
  end

  class SlotConstraints
    delegate :map, to: :@slots

    def initialize(slots)
      @slots = slots
    end

    def bookable_date?(requested_date)
      @slots.any? { |s| s.to_date == requested_date }
    end

    def last_bookable_date
      @slots.sort.last.to_date
    end
  end
end