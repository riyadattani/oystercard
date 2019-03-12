require "oystercard"

describe Oystercard do
  before(:each) do
    @card = Oystercard.new
  end

  it { is_expected.to respond_to(:balance) }
  it { is_expected.to respond_to(:top_up) }

  it "returns a starting balance of 0" do
    expect(@card.balance).to eq 0
  end

  it "should have a balance of 10 when user tops up 10" do
    @card.top_up(10)
    expect(@card.balance).to eq 10
  end

  it "increases balance by top up amount" do
    @card.top_up(10)
    @card.top_up(20)
    expect(@card.balance).to eq 30
  end

  it "allows top up to 1 below limit amount" do
    limit = Oystercard::DEFAULT_LIMIT
    expect(@card.top_up(limit - 1)).to eq limit - 1
  end

  it "has a default limit of £90" do
    limit = Oystercard::DEFAULT_LIMIT
    error = "Top-up exceeds £#{limit} balance limit. Add lower amount."
    @card.top_up(1)
    expect { @card.top_up(limit) }.to raise_error error
  end

  it { is_expected.to respond_to(:deduct) }

  it "deducts £10 from the balance" do
    @card.top_up(20)
    expect(@card.deduct(10)).to eq 10
  end

  it "deducts a user entered fare from the balance" do
    @card.top_up(50)
    expect(@card.deduct(20)).to eq 30
  end

  it { is_expected.to respond_to(:touch_in) }

  it "should show in journey as false at first" do
    expect(@card).to_not be_in_journey
  end

  it "should change in journey status to true when card touched in" do
    @card.top_up(5)
    @card.touch_in
    expect(@card).to be_in_journey
  end

  it "should change in journey status to false when card touched out" do
    @card.top_up(5)
    @card.touch_in
    @card.touch_out
    expect(@card).to_not be_in_journey
  end

  it "should have a minimum balance for a single journey" do
    expect { @card.touch_in }.to raise_error "Insufficient funds"
  end

  it "should deduct the minimum fare when touched out" do
    subject.top_up(5)
    subject.touch_in
    expect { subject.touch_out }.to change{ subject.balance }.by(-1)
  end





end
