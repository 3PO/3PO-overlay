## 3PO-overlay

### Usage

More recent versions of Portage allows you to add additional repositories by
adding a config file in `/etc/portage/repos.conf`. Here's an example:

```ini
[3PO-overlay]
location = /var/db/repos/3PO-overlay
sync-type = git
sync-uri = git://github.com/3PO/3PO-overlay.git
auto-sync = yes
```

Keyword as appropriate and use emerge like you normally would do.


### Contributing

Contributions are welcome.
Fork and create a pull request. 