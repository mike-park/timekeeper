require 'spec_helper'

describe BillItemsController do
  login_user

  before do
    PublicActivity.set_controller(@controller)
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BillsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  def valid_attributes
    bill = FactoryGirl.create(:bill)
    event = FactoryGirl.create(:event)
    {
        bill_id: bill.id,
        event_id: event.id
    }
  end

  def redirect_url(item)
    edit_therapist_bill_url(item.bill.therapist, item.bill)
  end

  describe "POST create" do
    render_views

    describe "with valid params" do
      it "creates a new bill item" do
        expect {
          post :create, {:bill_item => valid_attributes}, valid_session
        }.to change(BillItem, :count).by(1)
      end

      it "assigns a newly created bill item as @bill_item" do
        post :create, {:bill_item => valid_attributes}, valid_session
        assigns(:bill_item).should be_a(BillItem)
        assigns(:bill_item).should be_persisted
      end

      it "redirects to the created bill" do
        post :create, {:bill_item => valid_attributes}, valid_session
        response.should redirect_to(redirect_url(BillItem.last))
      end

      it "fades out the item" do
        attrs = valid_attributes
        post :create, {:bill_item => attrs, format: :js}, valid_session
        expect(response).to render_template('bill_items/create')
        expect(response.body).to match(/event_\d+.*fadeOut/)
      end
    end
  end

    describe "DELETE destroy" do
    render_views

    it "destroys the requested bill item" do
      item = FactoryGirl.create(:bill_item)
      expect {
        delete :destroy, {:id => item.to_param}, valid_session
      }.to change(BillItem, :count).by(-1)
    end

    it "redirects to the edit page" do
      item = FactoryGirl.create(:bill_item)
      delete :destroy, {:id => item.to_param}, valid_session
      expect(response).to redirect_to(redirect_url(item))
    end

    it "fades out the item" do
      item = FactoryGirl.create(:bill_item)
      delete :destroy, {:id => item.to_param, format: :js}, valid_session
      expect(response).to render_template('bill_items/destroy')
      expect(response.body).to match('fadeOut()')
    end
  end
end
