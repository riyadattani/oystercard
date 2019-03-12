class Oystercard
  attr_reader :balance
  DEFAULT_LIMIT = 90
  MINIMUM = 1

  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(amount)
    raise "Top-up exceeds £#{DEFAULT_LIMIT} balance limit. Add lower amount." if @balance + amount > DEFAULT_LIMIT

    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in
    raise "Insufficient funds" if @balance < MINIMUM

    @in_use = true
  end

  def touch_out
    @in_use = false

    deduct(MINIMUM)
  end

  def in_journey?
    @in_use
  end
end
