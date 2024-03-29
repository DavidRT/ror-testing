require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  # test "the truth" do
  #   assert true
  # end
  test "product attributes must not be empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
  	assert product.errors[:price].any?
  	assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
  	product = Product.new(
  			:title => "My book title",
  			:description => "yyy",
  			:image_url => "zzz.jpg"
  		)
  	product.price = -1
  	assert product.invalid?
  	assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')

  	product.price = 0
  	assert product.invalid?
  	assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')

  	product.price = 1
  	assert product.valid?
  end

  def new_product(image_url)
  	Product.new(:title => "My Book Title",
  				:description => "yyy",
  				:price => 1,
  				:image_url => image_url)
  end

  test "image_url" do
  	##testea que las extensiones de las rutas de imagenes
  	ok  = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
  	bad = %w{ fred.doc fred.gif/more fred.gif.more }

  	ok.each do
  		|name|
  			assert new_product(name).valid?, "#{name} shouldn't be invalid" 
  	end

  	bad.each do
  		|name|
  			assert new_product(name).invalid?,"#{name} shouldn't be valid"
  	end

  end

  test "product is not valid without a unique title" do
    product = Product.new(
        :title => products(:ruby).title,
      #  :title => "Hallo",
        :description => "yyyy",
        :price => 1,
        :image_url => "fred.gif")
    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')
  end

  test "product is not valid without a unique title - i18n" do
     product = Product.new(
        :title => products(:ruby).title,
       # :title => "Hallo",
        :description => "yyyy",
        :price => 1,
        :image_url => "fred.gif")
    assert !product.save
    assert_equal "has already been taken",product.errors[:title].join('; ' )
  end

  #valida que titulo tenga como minimo 10 caracteres.
  test "title is at least 10 characters long" do
    product = Product.new(:price => 9.99,
                          :description => "yyyy",
                          :image_url => "zzz.jpg")

    product.title = "this will be valid title"
    assert product.valid?, product.errors[:title].join('; ')
   # assert_equal "at least 10 characteres",product.errors[:title].join('; ')

    product.title = "this not"
    assert product.invalid?, product.errors[:title].join('; ')
   

    product.title = "this valid too"
   assert product.valid?, product.errors[:title].join('; ')
    

  end

end
