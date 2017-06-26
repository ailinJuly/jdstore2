class ProductsController < ApplicationController
  before_action :validate_search_key,only:[:search]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def add_to_cart
    @product = Product.find(params[:id])
      if !current_cart.products.include?(@product)
        current_cart.add_product_to_cart(@product)
        flash[:notice]="你已成功将 #{@product.title} 加入购物车"

      else
        flash[:warning]="这件商品已经在购物车内！"
      end
        redirect_to :back
  end

  def search
    if @query_string.present?
    # 顯示符合條件的商品
      search_result= Product.ransack(@search_criteria).result(:distinct=>true)
      @products = search_result.paginate(:page =>params[:page],:per_page=>5)
    end
  end


  protected

  def validate_search_key
# 去除特殊字符
    @query_string= params[:q].gsub(/\\|\'|\/|\?/, "") if params[:q].present?
    @search_criteria =search_criteria(@query_string)
  end
 # 配置搜索的字段
  def search_criteria(query_string)
    {:title_cont => query_string}
  end


end
