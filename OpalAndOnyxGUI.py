import tkinter as tk
from tkinter import messagebox
from tkinter import simpledialog

#import mysql.connector
cart = []


# Function to connect to the database
#def connect_to_db():
    #return mysql.connector.connect(
        #host="localhost",       
        #user="root",            
        #password="Blaze123",    
        #database="OpalAndOnyx"  
   # )

def create_window():
    window = tk.Tk()
    window.title("Opal & Onyx")

    label = tk.Label(window, text="Welcome to Opal & Onyx!", font=("Script", 32))
    label.pack(pady=20)

   # Button to display items in each collection
    collections_button = tk.Button(window, text="Collections", command=view_items_in_each_collection)
    collections_button.pack(pady=10)
    

    # Category selection (dropdown)
    category_label = tk.Label(window, text="Select Category")
    category_label.pack(pady=10)

    categories = get_categories()
    category_var = tk.StringVar(window)
    category_var.set(categories[0])  # Default category

    category_menu = tk.OptionMenu(window, category_var, *categories)
    category_menu.pack(pady=10)

    # Button to display items by selected category
    category_button = tk.Button(window, text="Display Items by Category", 
                                command=lambda: display_items_by_category(category_var.get()))
    category_button.pack(pady=10)


 # Button to display all items
    display_button = tk.Button(window, text="Shop All", command=display_items)
    display_button.pack(pady=10)

 #Cart button
    cart_label = tk.Label(window, text="View Cart")
    cart_label.pack(pady=10)
    
    cart_button = tk.Button(window, text="ðŸ›’", command=view_cart)
    cart_button.pack(pady=10)


    
    # Button to display orders with items in detail
    #orders_button = tk.Button(window, text="View Orders with Items in Detail", command=view_orders_with_items)
    #orders_button.pack(pady=10)

    window.mainloop()

#Function to add items to cart
def add_to_cart(item):
    cart.append(f"{item[1]} - ${item[2]}")
    messagebox.showinfo("Added to Cart", f"{item[1]} has been added to your cart.")

# Function to view cart contents   
def view_cart():
    if cart:
        cart_contents = "\n".join(cart)
        messagebox.showinfo("Cart", f"Items in cart:\n{cart_contents}")
    else:
        messagebox.showinfo("Cart", "Your cart is empty.")
            
# Function to get categories from the database
def get_categories():
    connection = connect_to_db()
    cursor = connection.cursor()
    cursor.execute("SELECT CategoryName FROM Category")
    categories = [category[0] for category in cursor.fetchall()]
    cursor.close()
    connection.close()
    return categories

# Function to display all items


# Function to display items by selected category
def display_items_by_category(category_name):
    connection = connect_to_db()
    cursor = connection.cursor()
    
    # Query to fetch category ID by name
    cursor.execute("SELECT CategoryID FROM Category WHERE CategoryName = %s", (category_name,))
    category_id = cursor.fetchone()

    if category_id:
        query = "SELECT ItemName, Price, Color FROM Item WHERE CategoryID = %s"
        cursor.execute(query, (category_id[0],))
        items = cursor.fetchall()

        if items:
            items_display = "\n".join([f"Item: {item[0]}, Price: ${item[1]}, Color: {item[2]}" for item in items])
            messagebox.showinfo("Items in Category", items_display)
        else:
            messagebox.showinfo("No Items", "No items found in this category.")
    

def display_items():
    connection = connect_to_db()
    cursor = connection.cursor()
    cursor.execute("SELECT ItemID, ItemName, Price FROM Item")
    items = cursor.fetchall()

    # Create a new window to list items
    items_window = tk.Toplevel()
    items_window.title("All Items")

    for item in items:
        item_frame = tk.Frame(items_window)
        item_frame.pack(pady=5)

        item_label = tk.Label(item_frame, text=f"{item[1]} - ${item[2]}")
        item_label.pack(side=tk.LEFT, padx=10)

        add_button = tk.Button(item_frame, text="Add to Cart", 
                               command=lambda i=item: add_to_cart(i))
        add_button.pack(side=tk.RIGHT, padx=10)

    cursor.close()
    connection.close()


# Function to view orders with items in detail
def view_orders_with_items():
    connection = connect_to_db()
    cursor = connection.cursor()

    # SQL query to get orders with item details
    query = """
    SELECT Orders.OrderID, CustomerAccount.FirstName, CustomerAccount.LastName, Item.ItemName, 
           OrderItem.Quantity, OrderItem.UnitPrice, (OrderItem.Quantity * OrderItem.UnitPrice) AS TotalPrice
    FROM Orders
    JOIN CustomerAccount ON Orders.CustomerID = CustomerAccount.CustomerID
    JOIN OrderItem ON Orders.OrderID = OrderItem.OrderID
    JOIN Item ON OrderItem.ItemID = Item.ItemID
    ORDER BY Orders.OrderDate DESC
    """
    
    cursor.execute(query)
    orders = cursor.fetchall()

    if orders:
        order_details = "\n".join([
            f"Order ID: {order[0]}, Customer: {order[1]} {order[2]}, Item: {order[3]}, Quantity: {order[4]}, "
            f"Unit Price: ${order[5]}, Total Price: ${order[6]}"
            for order in orders
        ])
        messagebox.showinfo("Orders with Items", order_details)
    else:
        messagebox.showinfo("No Orders", "No orders found in the database.")

    cursor.close()
    connection.close()

    
# Function to view items in each collection
def view_items_in_each_collection():
    connection = connect_to_db()
    cursor = connection.cursor()

    # SQL query to get collections and items in those collections
    query = """
    SELECT Collections.CollectionName, Item.ItemName, Item.Price, Item.Color
    FROM Collections
    JOIN Item ON Collections.CollectionID = Item.CollectionID
    ORDER BY Collections.CollectionName, Item.ItemName
    """
    
    cursor.execute(query)
    collection_items = cursor.fetchall()

    if collection_items:
        collection_display = ""
        current_collection = ""
        
        for collection in collection_items:
            if collection[0] != current_collection:
                if current_collection:
                    collection_display += "\n"
                collection_display += f"\nCollection: {collection[0]}"
                current_collection = collection[0]
            collection_display += f"\n - Item: {collection[1]}, Price: ${collection[2]}, Color: {collection[3]}"

        messagebox.showinfo("Items in Each Collection", collection_display)
    else:
        messagebox.showinfo("No Items", "No items found in any collection")

    cursor.close()
    connection.close()



# Run the application
create_window()
