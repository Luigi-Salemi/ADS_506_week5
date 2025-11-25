# Quick Start Guide

## Run the App Locally (Right Now!)

```r
# In R or RStudio, run:
shiny::runApp("app.R")
```

The app will open in your browser. Try these actions:
1. Select different wine varietals
2. Change the training end date to see how it affects forecasts
3. Toggle models on/off
4. Navigate through the three tabs

## Deploy to GitHub + Posit Connect Cloud (30 minutes)

### Step 1: Create GitHub Repository (5 min)
1. Go to https://github.com/new
2. Name: `australian-wine-forecasting` (or your choice)
3. **Important**: Make it PUBLIC
4. Do NOT add README, .gitignore, or license (we have them)
5. Click "Create repository"

### Step 2: Push Your Code (2 min)
```bash
# Replace YOUR_USERNAME and YOUR_REPO_NAME with your actual values
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git push -u origin main
```

### Step 3: Deploy to Posit Connect Cloud (10 min)
1. Go to https://connect.posit.cloud/
2. Sign in (or create free account)
3. Click "Publish" → "New Content"
4. Select "Shiny Application"
5. Choose "Import from Git"
6. Paste your GitHub repo URL
7. Branch: `main`
8. Content path: `app.R`
9. Click "Deploy"
10. Wait 5-10 minutes for deployment
11. Copy your app URL!

### Step 4: Create Your Data Story (10 min)
1. Open your deployed app
2. Explore and find an interesting pattern
3. Take 2-3 screenshots
4. Open `Week5_Submission.qmd`
5. Add your URLs and screenshots
6. Write your data story (1-2 pages)

### Step 5: Render and Submit (3 min)
```r
# In R:
quarto::quarto_render("Week5_Submission.qmd")
```

Or command line:
```bash
quarto render Week5_Submission.qmd
```

Rename the PDF to: `Week5_Salemi_Luigi.pdf`

Submit:
- Paste app URL in assignment comments
- Paste GitHub URL in assignment comments  
- Upload your PDF

## Done! 🎉

---

## Troubleshooting

**"quarto command not found"**
- Install Quarto: https://quarto.org/docs/get-started/
- Or use RStudio's built-in renderer

**"App won't deploy"**
- Ensure repository is PUBLIC
- Check that manifest.json exists
- Verify AustralianWines.csv is in the repo

**"Need help with data story"**
- Look at sparkling wine in December (huge spike!)
- Compare RMSE values across models
- Check which model has narrowest prediction intervals

---

## Files You Need to Edit

1. **Week5_Submission.qmd** - Add your name, URLs, and data story
2. That's it! Everything else is ready to go.

## Files You DON'T Need to Touch

- app.R (already complete)
- mockup.qmd (already complete)
- manifest.json (already generated)
- README.md (already written)
- All other files are ready

---

**Total time to complete: ~30 minutes** (after app is built, which is already done!)

