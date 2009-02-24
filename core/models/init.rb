require 'dm-core'
path = File.expand_path(File.dirname(__FILE__))

DataMapper.setup(:default, {
  :adapter  => 'mysql',
  :database => 'kiva_world',
  :username => 'root', # kiva
  :password => '', # to change!!
  :host     => 'localhost'
})

require File.join(path, 'loan')
require File.join(path, 'borrower')
require File.join(path, 'lender')