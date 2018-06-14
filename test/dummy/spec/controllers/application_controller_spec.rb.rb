# frozen_string_literal: true
require 'rails_helper'

describe ApplicationController, type: :controller do
  context 'accessing login' do
    context "when user don't have token" do
      before{ get :login }

      it { expect(response).to be_success }
      it { expect(json['error']).to be_eql("You need to login") }
      it { expect(response.cookies['T_SID']).to be_nil }
    end

    context "when user have token" do
      let (:cached_token) { token }

      before do 
        request.cookies['T_SID'] = cached_token
        get :login
      end

      it { expect(response).to be_success }
      it { expect(json['error']).to be_eql("You need to login") }
      pending
    end
  end

  describe 'accessing home' do

    context "when user don't have token" do
      pending
    end

    context "when user have token" do
      pending
    end
  end
end
