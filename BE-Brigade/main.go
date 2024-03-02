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

type OCRResult struct {
	Date                   string `json:"Date"`
	Weight                 string `json:"Weight"`
	BMI                    string `json:"BMI"`
	BodyFat                string `json:"Body Fat"`
	SubcutaneousFat        string `json:"Subcutaneous Fat"`
	VisceralFat            string `json:"Visceral Fat"`
	BodyWater              string `json:"Body Water"`
	SkeletalMuscle         string `json:"Skeletal Muscle"`
	MuscleMass             string `json:"Muscle Mass"`
	BoneMass               string `json:"Bone Mass"`
	Protein                string `json:"Protein"`
	BMR                    string `json:"BMR"`
	MetabolicAge           string `json:"Metabolic Age"`
	AvgScore               string `json:"Avg Score"`
	AvgRestingHeartRate    string `json:"Avg Resting Heart Rate"`
	AvgBodyBatteryChange   string `json:"Avg Body Battery Change"`
	AvgSpO2                string `json:"Avg SpO2"`
	AvgRespiration         string `json:"Avg Respiration"`
}

func main() {
	a := &App{}
	a.Initialize("root", "password", "dbname")
	a.Run(":8080")
}

func (a *App) Initialize(user, password, dbname string) {
	connectionString := fmt.Sprintf("%s:%s@tcp(127.0.0.1:3306)/%s?parseTime=true", user, password, dbname)
	db, err := sql.Open("mysql", connectionString)
	if err != nil {
		log.Fatal(err)
	}
	a.DB = db
	a.Router = mux.NewRouter()
	a.initializeRoutes()
}

func (a *App) Run(addr string) {
	corsHandler := handlers.CORS(handlers.AllowedHeaders([]string{"X-Requested-With", "Content-Type", "Authorization"}), handlers.AllowedMethods([]string{"GET", "POST", "PUT", "DELETE", "OPTIONS"}), handlers.AllowedOrigins([]string{"*"}))
	log.Fatal(http.ListenAndServe(addr, corsHandler(a.Router)))
}

func (a *App) initializeRoutes() {
	a.Router.HandleFunc("/login", a.loginHandler).Methods("POST")
	a.Router.HandleFunc("/signup", a.signupHandler).Methods("POST")
	a.Router.HandleFunc("/uploadImage", a.uploadImageHandler).Methods("POST")
	a.Router.HandleFunc("/storeOCRResult", a.storeOCRResultHandler).Methods("POST")
}

func (a *App) storeOCRResultHandler(w http.ResponseWriter, r *http.Request) {
    r.ParseMultipartForm(10 << 20)
    file, _, err := r.FormFile("image")
    if err != nil {
        http.Error(w, "Error retrieving the file", http.StatusBadRequest)
        return
    }
    defer file.Close()

    tempFile, err := os.CreateTemp("temp-images", "upload-*.jpg")
    if err != nil {
        http.Error(w, "Failed to create a temporary file", http.StatusInternalServerError)
        return
    }
    defer tempFile.Close()

    _, err = io.Copy(tempFile, file)
    if err != nil {
        http.Error(w, "Failed to write to temporary file", http.StatusInternalServerError)
        return
    }

    cmd := exec.Command("python3", "ocr_store_db.py", tempFile.Name())
    out, err := cmd.Output()
    if err != nil {
		errorMsg := fmt.Sprintf("Failed to execute Python script: %s\nOutput: %s", err.Error(), string(out))
		http.Error(w, errorMsg, http.StatusInternalServerError)
		return
	}

    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusOK)
    w.Write(out)
}




func (a *App) loginHandler(w http.ResponseWriter, r *http.Request) {
	var creds Credentials
	err := json.NewDecoder(r.Body).Decode(&creds)
	if err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}
	var hashedPassword string
	err = a.DB.QueryRow("SELECT password FROM users WHERE username=?", creds.Username).Scan(&hashedPassword)
	if err == sql.ErrNoRows {
		http.Error(w, "User not found", http.StatusUnauthorized)
		return
	} else if err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}
	if bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(creds.Password)) != nil {
		http.Error(w, "Incorrect password", http.StatusUnauthorized)
		return
	}
	json.NewEncoder(w).Encode(map[string]string{"message": "Login successful"})
}

func (a *App) signupHandler(w http.ResponseWriter, r *http.Request) {
	var creds Credentials
	err := json.NewDecoder(r.Body).Decode(&creds)
	if err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}
	var exists int
	err = a.DB.QueryRow("SELECT COUNT(*) FROM users WHERE username = ?", creds.Username).Scan(&exists)
	if err != nil {
		http.Error(w, "Database query error", http.StatusInternalServerError)
		return
	}
	if exists > 0 {
		http.Error(w, "Username already exists", http.StatusConflict)
		return
	}
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(creds.Password), bcrypt.DefaultCost)
	if err != nil {
		http.Error(w, "Failed to hash password", http.StatusInternalServerError)
		return
	}
	_, err = a.DB.Exec("INSERT INTO users (username, password) VALUES (?, ?)", creds.Username, hashedPassword)
	if err != nil {
		http.Error(w, "Database insert error", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(map[string]string{"message": "Signup successful"})
}

func (a *App) uploadImageHandler(w http.ResponseWriter, r *http.Request) {
    r.ParseMultipartForm(10 << 20)
    file, _, err := r.FormFile("image")
    if err != nil {
        http.Error(w, "Error retrieving the file", http.StatusBadRequest)
        return
    }
    defer file.Close()

    tempFile, err := os.CreateTemp("temp-images", "upload-*.jpg")
    if err != nil {
        http.Error(w, "Failed to create a temporary file", http.StatusInternalServerError)
        return
    }
    defer tempFile.Close()

    _, err = io.Copy(tempFile, file)
    if err != nil {
        http.Error(w, "Failed to write to temporary file", http.StatusInternalServerError)
        return
    }

    cmd := exec.Command("python3", "ocr_process.py", tempFile.Name())
    out, err := cmd.Output()
    if err != nil {
        http.Error(w, "Failed to process image with OCR: "+err.Error(), http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusOK)
    w.Write(out)
    
}

