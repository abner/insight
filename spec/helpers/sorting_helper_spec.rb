require 'rails_helper'

describe SortingHelper do
  include SortingHelper
  describe '#sort_argument_from_param of relato.asc,created_at.desc' do

    subject {
      sort_argument_from_param({sort: 'relato.asc,created_at.desc'})
    }

    context 'first sort argument' do
      it { expect(subject[0].name).to eq(:relato) }
      it { expect(subject[0].operator).to eq(1) }
    end

    context 'second sort argument' do
      it { expect(subject[1].name).to eq(:created_at) }
      it { expect(subject[1].operator).to eq(-1) }
    end

  end
end
