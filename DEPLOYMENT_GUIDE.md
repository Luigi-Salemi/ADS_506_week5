# Deployment Guide for Australian Wine Sales Forecasting App

## Prerequisites

- R (>= 4.0.0) installed
- Git installed
- GitHub account
- Posit Connect Cloud account (or Posit Cloud account)

## Step 1: Verify Local Functionality

Before deploying, ensure the app works locally:

```r
# Install required packages if not already installed
install.packages(c("shiny", "tidyverse", "fpp3", "gt", "urca", "lubridate"))

# Run the app
shiny::runApp("app.R")
```

The app should open in your browser at `http://localhost:3838` (or similar).

Test all features:
- [ ] Select different varietals
- [ ] Change date ranges
- [ ] Adjust forecast horizon
- [ ] Toggle models on/off
- [ ] Navigate through all tabs
- [ ] Verify plots and tables render correctly

## Step 2: Prepare for Deployment

### 2.1 Create Manifest File

The manifest file has already been created (`manifest.json`). This file lists all R package dependencies needed for deployment.

If you need to regenerate it:

```r
rsconnect::writeManifest()
```

### 2.2 Initialize Git Repository

Already done! The repository has been initialized with:

```bash
git init
git add .
```

To commit:

```bash
git commit -m "Initial commit: Australian Wine Sales Forecasting App"
```

## Step 3: Push to GitHub

### 3.1 Create GitHub Repository

1. Go to https://github.com
2. Click "New repository"
3. Name it (e.g., "australian-wine-forecasting")
4. Choose "Public" (required for free Posit Connect Cloud deployment)
5. Do NOT initialize with README (we already have one)
6. Click "Create repository"

### 3.2 Push Your Code

```bash
# Add remote
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 4: Deploy to Posit Connect Cloud

### Option A: Posit Connect Cloud

1. Go to https://connect.posit.cloud/
2. Sign in or create an account
3. Click "Publish" → "New Content"
4. Select "Shiny Application"
5. Choose "Import from Git"
6. Enter your GitHub repository URL
7. Select the branch (main)
8. Set the content path to `app.R`
9. Click "Deploy"

The deployment process will:
- Clone your repository
- Read `manifest.json` to install dependencies
- Launch your Shiny app
- Provide you with a public URL

### Option B: Posit Cloud (Alternative)

1. Go to https://posit.cloud/
2. Sign in or create account
3. Create a new project
4. Upload your files or connect to GitHub
5. Install packages in the R console:
   ```r
   install.packages(c("shiny", "tidyverse", "fpp3", "gt", "urca", "lubridate"))
   ```
6. Run the app and share the project

## Step 5: Test Deployed App

Once deployed:

1. Visit the provided URL
2. Test all functionality (same checklist as Step 1)
3. Verify that:
   - App loads within ~30 seconds
   - All plots render correctly
   - Tables display properly
   - No error messages appear
   - All interactive controls work

## Step 6: Complete Your Submission

### 6.1 Update Week5_Submission.qmd

1. Open `Week5_Submission.qmd`
2. Add your deployed app URL
3. Add your GitHub repository URL
4. Add your name and date
5. Create your data story with screenshots

### 6.2 Take Screenshots

For your data story, take screenshots showing:
- Interesting patterns in the Visualization tab
- Model specifications and accuracy comparisons
- Forecast plots highlighting your insights

Save screenshots and reference them in your submission document.

### 6.3 Render Submission Document

```r
# Install quarto package if needed
install.packages("quarto")

# Render to PDF
quarto::quarto_render("Week5_Submission.qmd")
```

Or use the command line:
```bash
quarto render Week5_Submission.qmd
```

### 6.4 Submit

1. Ensure your PDF is named: `Week5_Lastname_Firstname.pdf`
2. In the assignment submission:
   - Paste your app URL in the comments
   - Paste your GitHub URL in the comments
   - Upload your PDF

## Troubleshooting

### App won't deploy
- Check that `manifest.json` exists
- Verify repository is public
- Ensure `AustralianWines.csv` is in the repository

### Missing packages error
- Regenerate manifest: `rsconnect::writeManifest()`
- Ensure all packages are listed in the app.R library() calls

### Data not loading
- Verify `AustralianWines.csv` is in the same directory as `app.R`
- Check file path is relative, not absolute
- Ensure CSV file is committed to Git

### App runs locally but not on server
- Check R version compatibility
- Verify all packages are available on the deployment platform
- Review deployment logs for specific errors

## Additional Resources

- [Shiny Deployment Guide](https://shiny.posit.co/r/articles/share/deployment-overview/)
- [Posit Connect Cloud Documentation](https://docs.posit.co/connect/cloud/)
- [rsconnect Package Documentation](https://rstudio.github.io/rsconnect/)

## Support

If you encounter issues:
1. Check the deployment logs
2. Verify all files are in the repository
3. Test locally first
4. Consult course materials and lab sessions
5. Ask for help in course forums

