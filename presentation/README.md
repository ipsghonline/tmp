# SharePoint Migration User Presentation

## Overview

This presentation is designed for Teams calls with end users to communicate SharePoint migration details from Interior Logic Group to Impact Property Solutions tenant.

## Files

### Main Presentation
- **SharePoint-Migration-User-Guide.pptx** - Complete 12-slide presentation for general user communication

### Templates
- **templates/Per-Site-Template.pptx** - Customizable template for individual site/team meetings

### Assets
- **assets/images/** - Logo and dashboard screenshots (to be added)

## Quick Start

### For First-Time Use

1. **Open the presentation**
   ```
   Open SharePoint-Migration-User-Guide.pptx in PowerPoint
   ```

2. **Add your branding** (one-time setup)
   - View → Master → Slide Master
   - Add company logo to top-right corner of master slides
   - Update color scheme if needed (currently uses Microsoft 365 colors)
   - Close Master View

3. **Replace placeholders** (before EVERY presentation)
   - Search for `[YOUR` to find all placeholders that need editing
   - Common placeholders:
     - `[YOUR IT SUPPORT EMAIL]` → your actual support email
     - `[YOUR SUPPORT CHANNEL]` → Teams channel link
     - `[YOUR SUPPORT HOURS]` → e.g., "Monday-Friday 8am-6pm EST"
     - `[YOUR SLA]` → e.g., "4 hours for urgent, 24 hours for normal"

4. **Add dashboard screenshot** (Slide 10)
   - Navigate to http://10.0.0.89:8080/site-mapping.html
   - Take screenshot showing site list with status
   - In PowerPoint: Insert → Pictures → select screenshot
   - Replace placeholder text on Slide 10

5. **Update statistics** (if data changes significantly)
   - Slide 3: Total storage, sites, items
   - Slide 4: Complete/In Progress/Pending counts
   - Or: Re-run `python3 create-presentation.py` to regenerate with fresh data

### For Per-Site Meetings

1. **Use the template**
   ```
   Open templates/Per-Site-Template.pptx
   Save As: [SiteName]-Migration-Brief.pptx
   ```

2. **Customize for specific site**
   - Slide 1: Replace `[SITE NAME]` with actual site name
   - Slide 6 (Timeline): Fill in site-specific placeholders:
     - `[SITE NAME]` → e.g., "PS - Purchasing"
     - `[DATE/TIME]` → e.g., "January 20, 2026 at 6:00 PM EST"
     - `[X hours]` → Based on item count (see guidelines below)
     - `[XX,XXX items]` → From dashboard or site-mapping.json

3. **Duration estimates by size**
   - < 10,000 items: "30 minutes to 1 hour"
   - 10,000-50,000 items: "1-2 hours"
   - 50,000-100,000 items: "2-3 hours"
   - > 100,000 items: "3-5 hours"

## Slide-by-Slide Guide

### Slide 1: Title Slide
- **Purpose**: Welcome and set context
- **Editable**: Date (auto-generated, can be customized)
- **Speaker Notes**: Full introduction script included

### Slide 2: Why We're Migrating
- **Purpose**: Business rationale and benefits
- **Content**: 5 key benefits with checkmarks
- **Speaker Notes**: Talking points for each benefit, anticipated Q&A

### Slide 3: What's Being Migrated
- **Purpose**: Scope and scale
- **Content**: 126 sites, 1.64 TB, 1.2M+ items
- **Editable**: Statistics auto-populated from site-mapping.json
- **Speaker Notes**: Breakdown by department, examples

### Slide 4: Current Status
- **Purpose**: Real-time progress update
- **Content**: 29 complete (23%), 0 in progress, 97 pending
- **Editable**: Auto-updated when you re-run script
- **Key Feature**: Dashboard link prominently displayed
- **Speaker Notes**: How to demo dashboard, expected questions

### Slide 5: What Changes
- **Purpose**: Address user concerns about impact
- **Content**: Two columns: "What's Changing" vs "What's NOT Changing"
- **Critical Message**: URLs stay the same (repeat often!)
- **Speaker Notes**: Detailed explanations, examples, common questions

### Slide 6: Timeline (REQUIRES CUSTOMIZATION)
- **Purpose**: Site-specific migration schedule
- **Editable Placeholders** (RED TEXT):
   - `[SITE NAME]` - Replace with actual site name
   - `[DATE/TIME]` - When migration will occur
   - `[X hours]` - Expected duration based on size
   - `[XX,XXX items]` - File count for this site
- **Use**: Duplicate this slide for multiple sites or use Per-Site-Template
- **Speaker Notes**: Pre-flight checklist for customization

### Slide 7: During Migration
- **Purpose**: Set expectations for migration window
- **Content**: What users will/won't experience
- **Key Points**:
   - ✓ Site stays accessible
   - ⚠️ Brief slowdown (1-5 hours)
   - ⚠️ Shared links may be temporarily unavailable
   - ✓ No data loss
   - ✓ Automatic (no user action required)
- **Speaker Notes**: Detailed explanation of each point, best practices

### Slide 8: After Migration
- **Purpose**: Verification checklist
- **Content**: 5-point checklist for users to verify
- **Editable**: `[IT Support Email/Teams Channel]` - replace with actual contact
- **Speaker Notes**: How to verify each item, reporting process

### Slide 9: FAQ
- **Purpose**: Address common concerns
- **Content**: 5 most common questions with answers
- **Editable**: Last Q&A answer - replace `[YOUR IT SUPPORT CONTACT]`
- **Speaker Notes**: Extended answers, additional Q&A, handling techniques

### Slide 10: Dashboard Demo (NEEDS SCREENSHOT)
- **Purpose**: Show users how to self-serve status
- **Action Required**: Add actual dashboard screenshot
- **How to Capture**:
   1. Open http://10.0.0.89:8080/site-mapping.html
   2. Screenshot showing site list with columns visible
   3. Insert → Pictures in PowerPoint
   4. Replace placeholder text with image
- **Speaker Notes**: Live demo script, features to highlight

### Slide 11: Support & Resources (REQUIRES CUSTOMIZATION)
- **Purpose**: Provide support contact information
- **Editable Placeholders** (RED TEXT - MUST REPLACE):
   - `[YOUR IT SUPPORT EMAIL]` → e.g., itsupport@impactpropertysolutions.com
   - `[YOUR SUPPORT CHANNEL]` → e.g., Teams > IT Support > SharePoint Migration
   - `[YOUR DOCS LINK]` → e.g., Intranet > IT > Migration Guide
   - `[YOUR SUPPORT HOURS]` → e.g., Monday-Friday 8am-6pm EST
   - `[YOUR SLA]` → e.g., 4 hours urgent, 24 hours normal
- **Speaker Notes**: Escalation path, what to include in requests

### Slide 12: Key Takeaways
- **Purpose**: Reinforce critical messages
- **Content**: 5 key takeaways, Q&A prompt
- **Speaker Notes**: Closing script, Q&A facilitation, next steps

## Updating Statistics

### When to Update
- Before each major presentation series
- After significant migration milestones
- When statistics become noticeably outdated (>10% change)

### How to Update

**Option 1: Automatic (Recommended)**
```bash
cd presentation
python3 create-presentation.py
```
This regenerates the entire presentation with current data from `../site-mapping.json`

**Option 2: Manual**
1. Open site-mapping.json or dashboard
2. Note current statistics:
   - Total sites (currently 126)
   - Complete sites (currently 29)
   - In progress sites (currently 0)
   - Pending sites (currently 97)
   - Total storage (currently 1.64 TB)
3. Update Slide 3 and Slide 4 manually in PowerPoint

### What Gets Updated Automatically
When you re-run `create-presentation.py`:
- ✅ Total sites count
- ✅ Complete/In Progress/Pending counts
- ✅ Completion percentage
- ✅ Total storage (TB)
- ✅ Total items estimate

### What Stays the Same
- ❌ Support contact placeholders (you must still replace these)
- ❌ Site-specific timeline information (Slide 6)
- ❌ Dashboard screenshot (must be re-captured manually)
- ❌ Speaker notes (remain unchanged)

## Presenting Tips

### Preparation (30 minutes before)
1. ✅ Test PowerPoint opens and displays correctly
2. ✅ Test screen sharing in Teams (if remote)
3. ✅ Check dashboard is accessible: http://10.0.0.89:8080
4. ✅ Have site-mapping.json open for reference
5. ✅ Review speaker notes for each slide
6. ✅ Prepare to answer questions about specific sites

### During Presentation
- **Use Presenter View**: Shows speaker notes only to you
- **Enable Q&A**: Encourage questions throughout, not just at end
- **Show Dashboard Live**: If internet available, demo the dashboard on Slide 10
- **Be Flexible**: Skip or reorder slides based on audience technical level
- **Reference Context**: "As we discussed on Slide 5, URLs don't change..."

### Common Adaptations by Audience

**Technical Users (IT, Power Users)**:
- Spend more time on Slide 2 (Why - architecture benefits)
- Show live dashboard demo on Slide 10
- Deep-dive into FAQ with technical details
- Be prepared for API, permissions, workflow questions

**Non-Technical Users (General Staff)**:
- Keep it simple on Slide 2 (Why - user benefits)
- Use screenshot on Slide 10 (skip live demo)
- Focus heavily on Slide 5 (What Changes - reassurance)
- Emphasize: "URLs don't change, permissions stay same"

**Department Heads / Managers**:
- Emphasize Slide 3 (Scope - project scale)
- Customize Slide 6 with their specific site timeline
- Add slide with business impact analysis (optional)
- Provide written summary for distribution to team

**External Users / Partners**:
- Add context: who Interior Logic Group and Impact Floors are
- Clarify: external sharing still works (Slide 5)
- Emphasize: their login/access method doesn't change
- Provide direct IT contact for external user issues

## Distribution Options

### Email Distribution
1. **PowerPoint File**
   - Save as: SharePoint-Migration-Brief.pptx
   - Attach to email
   - Recipients can review at their own pace

2. **PDF Version**
   - File → Save As → PDF
   - Better for mobile viewing
   - Can't be easily edited by recipients
   - Include clickable links (test before sending)

### Teams Distribution
1. **Teams Channel**
   - Upload to Files tab
   - Pin message with link
   - @mention relevant team members

2. **Teams Meeting**
   - Add to meeting as attachment
   - Screen share during call
   - Record meeting for later viewing

### SharePoint Distribution
1. **News Post**
   - Upload as attachment to SP News article
   - Embed key slides as images
   - Add summary text

2. **Document Library**
   - Create "Migration Resources" folder
   - Upload presentation + supporting docs
   - Share folder link broadly

## Customization Guide

### Adding Your Logo

1. **Open Master Slide View**
   - View tab → Slide Master

2. **Select Master Slide**
   - Top slide in left pane (affects all slides)

3. **Insert Logo**
   - Insert tab → Pictures → Select logo file
   - Resize to ~0.5" height
   - Position in top-right corner
   - Make it small and unobtrusive

4. **Repeat for Other Masters** (if multiple layouts)
   - Apply to each master layout you're using
   - Maintain consistent position/size

5. **Close Master View**
   - Slide Master tab → Close Master View

### Changing Colors

**Option 1: Use Design Themes**
1. Design tab → Themes → Select built-in theme
2. Or: Design → Variants → Colors → Customize Colors
3. Map to your brand:
   - Text/Background: Your primary colors
   - Accent 1: Your primary brand color (replaces Microsoft Blue)
   - Accent 2: Your secondary color

**Option 2: Find and Replace Colors**
1. Home → Replace → Replace Fonts (or Colors if available)
2. Or manually: Select shape → Format → Shape Fill

**Current Colors (Microsoft 365 Defaults)**:
- Primary (titles, links): `#0078D4` (Microsoft Blue)
- Success (checkmarks): `#107C10` (Green)
- Warning (alerts): `#FFB900` (Orange)
- Error (problems): `#D13438` (Red)

### Adding Slides

**Between Existing Slides**:
1. Right-click where you want to insert
2. New Slide → Select layout
3. Or: Duplicate existing slide and modify

**Common Additions**:
- **Department-Specific Slide**: After Slide 3
  - List sites relevant to this department
  - Customize timeline for their sites only
- **Technical Deep-Dive**: After Slide 2
  - For IT audiences: API, permissions, architecture
- **Impact Analysis**: After Slide 6
  - Business impact, downtime windows, contingencies
- **Training Resources**: After Slide 11
  - Links to help articles, video tutorials, training schedule

## Troubleshooting

### Presentation Won't Open
- **Cause**: PowerPoint version incompatibility
- **Fix**: Try opening in PowerPoint Online or different version
- **Prevention**: Save As → PowerPoint 97-2003 (.ppt) for compatibility

### Fonts Look Different
- **Cause**: Segoe UI not installed on system
- **Fix**: Embed fonts: File → Options → Save → Embed fonts
- **Alternative**: Use Calibri (universally available)

### Links Don't Work
- **Cause**: PowerPoint disabled hyperlinks for security
- **Fix**: File → Options → Trust Center → Trust Center Settings → Trusted Locations → Add presentation folder
- **Test**: Click dashboard link before presenting

### Images/Logo Blurry
- **Cause**: Low resolution source file
- **Fix**: Use high-res logo (at least 300 DPI)
- **Alternative**: Use vector format (SVG) if PowerPoint supports

### Transitions Too Slow
- **Cause**: Computer performance during screen share
- **Fix**: Transitions → Duration → 0.5 seconds (fast)
- **Alternative**: Remove all transitions: Transitions → None → Apply to All

### Speaker Notes Not Visible
- **Cause**: Not in Presenter View
- **Fix**: Slideshow → From Beginning → Right-click → Show Presenter View
- **Alternative**: Print notes: File → Print → Full Page Slides → Notes Pages

## Best Practices

### Before Presenting
- ✅ Test in actual presentation environment (Teams, projector, etc.)
- ✅ Have backup: PDF version, printed notes
- ✅ Check all links are clickable
- ✅ Verify dashboard is accessible from presentation location
- ✅ Time your presentation (aim for 30-40 minutes with Q&A)

### During Presenting
- ✅ Use speaker notes as a guide, not a script
- ✅ Pause for questions after each major section
- ✅ Maintain eye contact (don't just read slides)
- ✅ Show enthusiasm and confidence
- ✅ Acknowledge when you don't know an answer

### After Presenting
- ✅ Send follow-up email with presentation attached
- ✅ Share dashboard link again
- ✅ Provide support contact information
- ✅ Note common questions for FAQ updates
- ✅ Request feedback for improvement

## FAQs

### Q: Can I edit the speaker notes?
**A:** Yes! They're suggestions. Customize for your style and audience.

### Q: How do I add speaker notes?
**A:** View → Notes → Type in notes section below slide.

### Q: Can I reorder slides?
**A:** Yes! Slide Sorter view → drag slides. Logical flow matters more than current order.

### Q: Should I include all 12 slides?
**A:** No. Skip slides not relevant to your audience. Common: Skip Slide 6 for general meetings, use only for specific site meetings.

### Q: How often should I update?
**A:** Update statistics monthly or when >10% change. Update placeholders before EVERY presentation.

### Q: Can I translate this?
**A:** Yes! Text is all editable. Consider professional translation for official use.

### Q: What about voice-over?
**A:** Slideshow → Record Slideshow → record narration on each slide for self-service viewing.

## Support

### For Technical Issues with Presentation
- Check PowerPoint version compatibility
- Try opening in PowerPoint Online
- Export as PDF if PowerPoint unavailable

### For Migration Content Questions
- Reference: ../site-mapping.json (source data)
- Dashboard: http://10.0.0.89:8080 (live data)
- Plan: /home/sully/.claude/plans/witty-zooming-milner.md (implementation details)

### For Regenerating Presentation
```bash
cd /home/sully/shwiz.viyu.net/_demo/e2e-migration/_impact-migration/presentation
python3 create-presentation.py
```

## Version History

### v1.0 (2026-01-12)
- Initial creation with 12 slides
- Based on 126 sites, 29 complete (23%)
- Includes per-site template
- Comprehensive speaker notes
- Placeholder-based customization approach

### Future Enhancements
- [ ] Add dashboard screenshot automatically
- [ ] Generate per-site presentations in batch
- [ ] Include video tutorial links
- [ ] Multi-language support
- [ ] Automated scheduling integration

## Files in This Directory

```
presentation/
├── SharePoint-Migration-User-Guide.pptx    (Main presentation - 12 slides)
├── create-presentation.py                   (Script to regenerate)
├── README.md                                (This file)
├── assets/
│   └── images/
│       ├── company-logo.png                (To be added by you)
│       └── dashboard-screenshot.png        (To be added by you)
└── templates/
    └── Per-Site-Template.pptx              (Customizable site-specific template)
```

## Contact

**For questions about this presentation toolkit:**
- Script Issues: Check create-presentation.py comments
- Content Questions: Review speaker notes in PowerPoint
- Data Updates: Re-run create-presentation.py with fresh site-mapping.json

**For migration-specific questions:**
- Dashboard: http://10.0.0.89:8080
- Support: [YOUR IT SUPPORT EMAIL] (replace this placeholder!)

---

**Ready to present? Remember:**
1. Replace [PLACEHOLDER TEXT] with real info
2. Add your company logo
3. Test in Teams screen share
4. Review speaker notes
5. Be confident - you've got this! 🎯
