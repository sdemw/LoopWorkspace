# Manual Localization Instructions

> This is work-in-progress. There are some open questions on how to deal with certain strings.

Table of Contents:

* Overview
    * Overview: From LoopWorkspace to lokalise
    * Overview: From lokalise to LoopWorkspace
    * Open questions and notes
* Loop Dashboard at lokalise
* Script Usage
* From LoopWorkspace to lokalise
    * Prepare xliff_out folder
    * Update lokalise strings
* Translations
* From lokalise to LoopWorkspace
    * Download from lokalise
    * Import xliff files into LoopWorkspace
    * Review Differences
    * Commit Changes and Create PRs
    * Review the Open PR and merge
* Finalize with PR to LoopWorkspace
* Utility Scripts

## Overview

Several scripts were created in 2023 to automate the localization process. (Refer to these as the original scripts.)

* export_localizations.sh
* import_localizations.sh
* update_submodule_refs.sh

New scripts were created in 2025 to provide smaller steps for the import process and to allow review before the modifications are committed and PR are opened.

* The "export" refers to exporting localization from LoopWorkspace and associated submodules into xliff files
* The "import" refers to importing xliff files from lokalise to provide updated localization for LoopWorkspace and associated submodules

### Overview: From LoopWorkspace to lokalise

For details, see [From LoopWorkspace to lokalise](#from-loopworkspace-to-lokalise)

This script prepares xliff files for each language (for all repositories) from LoopWorkspace suitable to be uploaded to lokalise:

* export_localizations.sh

> An older version of export_localization included an automated upload to lokalise:
> * until I know why this was removed, I'll stick with the manual drag and drop described under [Script Usage](#script-usage)
> * see https://github.com/LoopKit/LoopWorkspace/commit/47c2a4f

### Overview: From lokalise to LoopWorkspace

For details, see [From lokalise to LoopWorkspace](#from-lokalise-to-loopworkspace)

These scripts break the original import_localizations script into smaller components:

* manual_download_from_lokalise.sh
* manual_import_localizations.sh
* manual_review_translations.sh
* manual_finalize_translations.sh

### Open questions and notes

> Notes from Marion Barker:

#### Question 1:

I do not believe these keys should be included in the translation process:

* CFBundleGetInfoString
* CFBundleNames
* NSHumanReadableCopyright

These were almost all empty. I deleted these keys on 2025-07-27 on the lokalise site.

A few of them did have entries for some languages

> I have them archived locally and can restore them if they should have been kept

When uploading a new set of xliff_out files, they are recreated - so I think I'm missing a method to limit them.

Note that in the xliff files, these say translate="no", so why do they show up in the imported list on lokalise?

I will keep looking for help in the documentation, but if anyone knows - let me know.

> Because of this uncertainty, I only modified the LibreTransmitter project, so far, along with a hotfix needed for it.

#### Question 2:

A lot of the changes that were proposed were white space changes. If we need to make these whitespace changes, then we can do so. But if there's a method I missed to avoid them, I'd prefer to take that.

Here's an example:

```
diff --git a/RileyLinkKitUI/nb.lproj/Localizable.strings b/RileyLinkKitUI/nb.lproj/Localizable.strings
index fbfc31e..db53cbd 100644
--- a/RileyLinkKitUI/nb.lproj/Localizable.strings
+++ b/RileyLinkKitUI/nb.lproj/Localizable.strings
@@ -74,7 +74,7 @@
 "Name" = "Navn";
 
 /* Detail text when battery alert disabled.
-   Text indicating LED Mode is off */
+Text indicating LED Mode is off */
 "Off" = "Av";
 
 /* Text indicating LED Mode is on */
@@ -87,7 +87,7 @@
 "Signal Strength" = "Signalstyrke";
 
 /* The title of the section for orangelink commands
-   The title of the section for rileylink commands */
+The title of the section for rileylink commands */
 "Test Commands" = "Testkommandoer";
 
 /* The title of the cell showing Test Vibration */
```

There are other substantive changes in other projects, but there is so much noise from the white space changes, I would like to modify this so only translation updates are included if possible.

#### Question 3:

Both OmniBLE and OmniKit seem to be adding new xx.lproj folders at the top level with the languages already being present in other folders. These have associated changes to the `pbxproj` file. I'm confused by this and wonder if this is something that should be fixed.

#### Status on 2025-08-10

Updated the LocalizationInstructions.md file after running through the sequence documented in this file:

1. Download from lokalise (manual_download_from_lokalise.sh)
2. Import into LoopWorkspace (manual_import_localizations.sh)
3. Review Differences (manual_review_translations.sh)
4. Commit Changes and Create PRs (manual_finalize_translations.md)

Only 4 PR were opened because of permission limits and desire to go over the method before finalizing. All 4 PR were converted to drafts.

> These were created with the updated scripts and will be discussed before merging. They exhibit questions 1, 2 and 3.

## Loop Dashboard at lokalise

When you log into the [lokalise portal](https://app.lokalise.com/projects), navigate to the Loop dashboard, you see all the languages and the % complete for translation.

## Script Usage

The export_localization and manual_download_from_lokalise scripts require a LOKALISE_TOKEN. Right now, the export script does not use the token, but when it did, the token needed write access. The import script requires read privileges.

If a user is a manager for the Loop project at lokalise, they create a LOKALISE_TOKEN (API token) and use those scripts after generating their own token and exporting that token, e.g.,

```
export LOKALISE_TOKEN=<token>
```

Be sure to save the token in a secure location.

## From LoopWorkspace to lokalise

### Prepare xliff_out folder

The `export_translations.sh` script is used to update the strings in lokalise for translation.

It is normally required for any code updates that add or modify the strings that require localization.

First navigate to the LoopWorkspace directory in the appropriate branch, normally this is the `dev` branch. Make sure it is fully up to date with GitHub.

Make sure the scripts are executable. You may need to apply `chmod +x` to the scripts.

Make sure the Xcode workspace is **not** open on your Mac or this will fail.

```
./Scripts/export_localizations.sh
```

This creates an xliff_out folder filled with xliff files, one for each language, that contains all the keys and strings for the entire clone (including all submodules).

> An older version of export_localization included an automated upload to lokalise:
> * until I know why this was removed, I'll stick with the manual drag and drop described below
> * see https://github.com/LoopKit/LoopWorkspace/commit/47c2a4f


### Update lokalise strings

This section requires the user have `manager` access to the Loop project.

Log into the [lokalise portal](https://app.lokalise.com/projects) and navigate to Loop.

Select [Upload](https://app.lokalise.com/upload/414338966417c70d7055e2.75119857/)

Drag the *.xliff files from the xliff_out folder (created by export_localizations.sh) into the drag and drop location.

Be patient

* while each language is uploaded, the `uploading` indicator shows up under each language on the left side
* at the bottom of the list, the `Import Files` should be available when all have completed uploading
    * Tap on `Import Files`
* progress will show at upper right

When this is done, check the Loop lokalise dashboard again to see updated statistics.


## Translations

The translations are performed by volunteers. To volunteer, join [Loop zulipchat](https://loop.zulipchat.com/) and send a direct message to Marion Barker with your email address and the language(s) you can translate.


## From lokalise to LoopWorkspace

This has been broken into 4 separate scripts to allow review at each step.

### Download from lokalise

The `manual_download_from_lokalise.sh` script requires a LOKALISE_TOKEN with at least read privileges, see [Script Usage](#script-usage).

This script deletes any existing xliff_in folder and downloads the localization information from lokalise into a new xliff_in folder.

### Import xliff files into LoopWorkspace

Bullet summary of the `manual_import_translations.sh` script:

* create `translations` branch for each submodule (project)
* command-line Xcode build before importing xliff files
* command-line Xcode build for each language importing from the associated xliff file
* after completion, LoopWorkspace has uncommitted changes in projects

The `manual_import_translations.sh` script pulls the most recent tip from each submodule, creates a `translations` branch at that level in preparation for importing the localizations from xliff_in into LoopWorkspace and all the submodules.

> Warning: this deletes any existing `translations` branch from each submodule. If you need to "save your work", check out [Utility Scripts](#utility-scripts).

It then goes through each language and brings in updates from the xliff_in folder.

The result is that any updated localizations shows up as a diff in each submodule.

> The default branch name used for all the submodules is `translations`. If you want to modify that, edit the script and change `translation_dir` before executing the script. However, if you decide to do this, you have to edit it for 3 scripts: import, review and finalize. Really best to stick with `translations` as the branch name.

Before running this script:

* Confirm the list of `projects` in the script is up to date regarding owner, repository name, repository branch
* Trim any branches on GitHub with the name `translations`
    * The trimming should have happened when the last set of translations PR were merged
    * If not, do it now

Execute this script:

```
./Scripts/manual_import_localizations.sh
```

### Review Differences

Use the `manual_review_translations.sh` script in one terminal and open another terminal if you want to look in detail at a particular submodule:

```
./Scripts/manual_review_translations.sh
```

After each submodule, if any differences are detected, the script pauses with the summary of files changed and allows time to do detailed review (in another terminal). Hit return when ready to continue the script.

Examine the diffs for each submodule to make sure they are appropriate.

> In earlier tests, there are some changes that are primarily white space, so I did not commit those. See question 2 in [Open questions and notes](#open-questions-and-notes).

### Commit Changes and Create PRs

Bullet summary of action for each submodule by the `manual_finalize_translations.sh` script:

* if there are no changes, no action is taken
* if there are changes
    * git add .; commit all with automated message
    * push the `translations` branch to origin
    * create a PR from `translations` branch to default branch for that repository
    * open the URL for the PR

You should have trimmed any `translations` branches on any GitHub repositories before running the import script. If not, do it before running the `manual_finalize_translations.sh` script.

Once all the diffs have been reviewed and you are ready to proceed, run this script:

```
./Scripts/manual_finalize_translations.sh
```

Assuming the permission are ok for each repository that is being changed, this should run without errors, create the PRs and open each one.

If the person running the script does not have appropriate permissions to push the branch, the commits are already made for that repository before attempting to push, so the user can just run the script again to proceed to the next repository.

The missing PR need to be handled separately. But really the person running the script should have permissions to open new PR.

### Review the Open PR and merge

At this point, get someone to approve each of the open PR and merge them. Be sure to trim the `translations` branch once the PR are merged.

## Finalize with PR to LoopWorkspace

Once all the localization PR have been finished and merged, LoopWorkspace needs to be updated as well. Below are some of the CLI steps that could be used. Probably want to create another manual script.

Prepare the local clone for updates and create a new branch:

```
git switch dev
git pull --recurse
git switch -c translations
```

Update all submodules to the latest tip of their branches - this brings in all the new translations:

```
./Scripts/update_submodule_refs.sh
```

Replace TESTDATE below
```
git commit -am "update submodules: import lokalise translations TESTDATE"
git push --set-upstream origin translations
```

Create the PR from this branch.

```
gh pr create -B dev  -R LoopKit/translations --fill 
```

All the actions above can be done with a script once one is prepared.

## Utility Scripts

If you need to start over but don't want to lose prior work, edit this script for name of the branch to archive the translations and execute it. This is suitable for use after manual_import_localizations and manual_review_translations and before manual_finalize_translations.

* archive_translations.sh
    * internal names that can be edited:
        * archive_dir="test_translations"
        * translation_dir="translations"
