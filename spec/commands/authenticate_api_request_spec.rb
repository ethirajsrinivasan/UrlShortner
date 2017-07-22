require 'rails_helper'

describe AuthorizeApiRequest do
  subject(:context) { described_class.call() }

  describe '.call' do
    let(:user) { FactoryGirl.create(:user) }
    context 'when the context is successful' do
      it 'succeeds' do
        allow_any_instance_of(AuthorizeApiRequest).to receive(:user).and_return(user)
        expect(context).to be_success
      end
    end

    context 'when the context is not successful' do
      it 'fails' do
        expect(context).to be_failure
      end
    end
  end
end