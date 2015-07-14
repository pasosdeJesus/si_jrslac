# encoding: UTF-8

FactoryGirl.define do
  factory :poa, class: 'Poa' do
    id 1000 # Buscamos que no interfiera con existentes
    nombre "Poa"
    fechacreacion "2015-07-09"
    created_at "2015-07-09"
  end
end
