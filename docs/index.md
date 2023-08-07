---
hide:
  - navigation
---

# Eric Bouchut

Hi I'm Eric.  
From there you can learn more [about me](blog/about), [get in touch with me](blog/contact) or read my [blog](blog).  

If you are lost and like subway maps then this one is for you.

```mermaid
gitGraph:
    commit id: "Home" type: HIGHLIGHT
    branch about
	branch contact
    branch tags
    branch archive
    branch notes
    branch categories

	checkout contact
    commit id: "Contact" type: HIGHLIGHT
    commit id: "LinkedIn"
    commit id: "GitHub"
    commit id: "Twitter"
	commit id: "X" type: REVERSE
	commit id: "Mastodon"
	checkout main
	merge contact
	
	checkout about
    commit id: "About" type: HIGHLIGHT
    checkout main
	merge about

	checkout notes
	commit tag: "WIP: Learn in Public with Obsidian"
```