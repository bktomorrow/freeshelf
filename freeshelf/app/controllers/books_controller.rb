class BooksController < ApplicationController
  before_action :authorize!, except: [:index, :show]

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end


  def edit
      @book = Book.find(params[:id])
      unless @book.user == current_user
        redirect_to books_path
      end
    end

  def create
    @book = Book.new(book_params)
    @book.user = current_user

    if @book.save
      redirect_to @book, notice: 'Book was successfully created.'
    else
      render :new
    end
  end

  def update
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
      return
    end

    if @book.update(book_params)
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
      return
    end

    @book.destroy
    redirect_to books_url, notice: 'Book was successfully destroyed.'
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :description, :url)
  end
end
