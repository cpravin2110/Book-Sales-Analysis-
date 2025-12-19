-- Create Table Books

DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);


--Create Table Customers

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);


--Create Table Orders

DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;



-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'D:\Data Analyst\SQL\Practice Files SQL Projects\Books.csv' 
CSV HEADER;


-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'D:\Data Analyst\SQL\Practice Files SQL Projects\Customers.csv' 
CSV HEADER;


-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'D:\Data Analyst\SQL\Practice Files SQL Projects\Orders.csv' 
CSV HEADER;



-- 1) Retrieve all books present in the "Fiction" genre -->

SELECT * FROM Books
where genre = 'Fiction';


-- 2) Find books published after the year 1950 -->

SELECT * from books
where published_year > 1950 ;


-- 3) List all customers from the Canada -->

SELECT *From customers
where country = 'Canada';



-- 4) Show orders placed in November 2023 -->

select * from orders
where order_date Between '2023-11-01' And '2023-11-30';


-- 5) Retrieve the total stock of books available -->

select sum(stock) As Total_book_stock from books;


-- 6) Find the details of the most expensive book -->

select * from books
order by price desc limit 1;


-- 7) Show all customers who ordered more than 1 quantity of a book -->

select * from orders
where quantity > 1;


-- 8) Retrieve all orders where the total amount exceeds $20 -->

select * from orders
where total_amount > 20 ;


-- 9) List all genres available in the Books table -->

select Distinct genre from books ;


-- 10) Find the 5 books with the lowest stock -->

select * from books
order by stock limit 5 ;

-- 11) Calculate the total revenue generated from all orders -->

select sum(total_amount) As Total_revenue from orders ;


-- Advanced Queries -->


-- 1) Retrieve the total number of books sold for each genre -->

select b.genre , sum(o.quantity) As total_books_sold
from orders o
Join Books b on o.Book_ID =b.Book_ID
Group by b.genre ;


-- 2) Find the average price of books in the "Fantasy" genre -->

select avg(price) as Average_price 
from books
where genre = 'Fantasy' ;

-- 3) List customers who have placed at least 2 orders -->

select customer_id ,count(order_id) as order_count 
from orders
group by customer_id
having count(order_id) >=2 ;


-- 4) Find the most frequently ordered book -->

select book_id ,count(order_id) as order_count
from orders
group by book_id
order by order_count desc limit 1 ;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre -->

select * from books
where genre = 'Fantasy'
order by price desc limit 3;


-- 6) Retrieve the total quantity of books sold by each author -->

select b.author ,sum(o.quantity) as total_quantity_of_Books_sold
from orders o
join books b on b.book_id=o.book_id
group by b.author;


-- 7) List the cities where customers who spent over $30 are located -->

select distinct c.city
from orders o
join customers c on c.customer_id=o.customer_id
where total_amount > 30 ;

-- 8) Find the customer who spent the most on orders:

select c.Customer_id ,c.name ,sum(o.total_amount) as Total_amount_spend
from orders o
join customers c on c.customer_id=o.customer_id
group by c.customer_id , c.name
order by Total_amount_spend desc limit 1 ;


--9) Calculate the stock remaining after fulfilling all orders -->

SELECT b.Book_ID, b.Title, b.Stock - COALESCE(SUM(o.Quantity), 0) AS Remaining_Stock
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID;

----------------------------------OR------------------------------------

SELECT b.Book_ID, b.Title, b.Stock, COALESCE(SUM(o.Quantity), 0) AS order_quantity, 
		b.Stock - COALESCE(SUM(o.Quantity), 0) AS Remaining_stock
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID;



