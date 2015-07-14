# encoding: UTF-8

require 'rails_helper'

RSpec.describe Poa, :type => :model do

  it "valido" do
    poa = FactoryGirl.build(:poa)
    expect(poa).to be_valid
    poa.destroy
  end

  it "no valido" do
    poa = 
      FactoryGirl.build(:poa, nombre: '')
    expect(poa).not_to be_valid
    poa.destroy
  end

  it "existente" do
    skip
    poa = ::Poa.where(id: 1).take
    expect(poa.nombre).to eq("SIN INFORMACIÓN")
  end

end
