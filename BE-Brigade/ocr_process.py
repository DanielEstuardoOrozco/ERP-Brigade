package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	_ "github.com/go-sql-driver/mysql"
	"golang.org/x/crypto/bcrypt"
)

type App struct {
	Router *mux.Router
	DB     *sql.DB
}

type Credentials struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

type ImageData struct {
	Image string `json:"image"`
}
import sys
import json
import re
from PIL import Image
import pytesseract
import pymysql.cursors

def ocr_process(image_path, keywords):
    try:
        text = pytesseract.image_to_string(Image.open(image_path), lang='eng')
        structured_data = parse_text_to_structured_data(text, keywords)
        return {"success": True, "data": structured_data}
    except Exception as e:
        return {"success": False, "error": str(e)}

def parse_text_to_structured_data(text, keywords):
    data = {}
    for keyword in keywords:
        data[keyword] = find_metric(text, keyword)
    return data

def find_metric(text, keyword):
    pattern = rf"{re.escape(keyword)}\s*[:\-]?\s*([0-9]+\.?[0-9]*)\s*([a-zA-Z%]+)?"
    match = re.search(pattern, text, re.IGNORECASE)
    
    if match:
        value, unit = match.groups()
        if unit:
            return f"{value} {unit}".strip()
        return value
    return "Not found"

def clean_data(data):
    cleaned_data = {}
    for key, value in data.items():
        if isinstance(value, str):
            cleaned_value = re.sub(r'[^\d.]+', '', value)
            cleaned_data[key] = float(cleaned_value) if cleaned_value else None
        else:
            cleaned_data[key] = value
    return cleaned_data

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(json.dumps({"success": False, "error": "Usage: python script.py <image_path> <json_keywords_file>"}))
        sys.exit(1)
    
    image_path = sys.argv[1]
    json_keywords_file = 'data-structure.json'  # Default JSON file name
    
    # If a specific JSON file path is provided as an argument, use it instead
    if len(sys.argv) == 2:
        json_keywords_file = sys.argv[2]
    
    try:
        with open(json_keywords_file, 'r') as file:
            keywords = json.load(file)
        result = ocr_process(image_path, keywords)
        print(json.dumps(result))
        
        # Store data in the database using insert statements
        if result.get("success", False):
            data = result.get("data", {})
            cleaned_data = clean_data(data)  # Clean the data
            
            connection = pymysql.connect(host='localhost',  
                             port=3306,         
                             user='root',
                             password='Dorada111',
                             db='development',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)
            try:
                with connection.cursor() as cursor:
                    # Insert data into Tbl_Health
                    cursor.execute("INSERT INTO Tbl_Health (ID_User, Last_Modification_Date, Update_Date, Delete_Date, Active, Weight, Subcutaneous_Fat, Vicelar_Fat, Body_Water, Skeletal_Muscle, Muscle_Mass, Bone_Mass, Protein, BMR, Metabolic_Age) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                                   (None, None, None, None, None, 
                                    cleaned_data.get("Last_Modification_Date"), 
                                    cleaned_data.get("Update_Date"), 
                                    cleaned_data.get("Delete_Date"), 
                                    cleaned_data.get("Active"), 
                                    cleaned_data.get("Weight"), 
                                    cleaned_data.get("Subcutaneous_Fat"), 
                                    cleaned_data.get("Vicelar_Fat"), 
                                    cleaned_data.get("Body_Water"), 
                                    cleaned_data.get("Skeletal_Muscle"), 
                                    cleaned_data.get("Muscle_Mass"), 
                                    cleaned_data.get("Bone_Mass"), 
                                    cleaned_data.get("Protein"), 
                                    cleaned_data.get("BMR"), 
                                    cleaned_data.get("Metabolic_Age")))

                connection.commit()
            finally:
                connection.close()
    except FileNotFoundError:
        print(json.dumps({"success": False, "error": f"File {json_keywords_file} not found"}))
    except json.JSONDecodeError:
        print(json.dumps({"success": False, "error": "Error decoding JSON from keywords file"}))

    