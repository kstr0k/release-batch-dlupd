# release-batch-dlupd

Download & update packages, e.g. from GitHub releases. Features:
* uses [GitHub CLI `gh`](https://github.com/cli/cli/releases) (required) & token, avoiding rate limits
* can detect updates even for fixed release URLs / tags (e.g. `releases/tag/continuous`) using the GitHub API

## Usage

See `release-batch-dlupd --help`:
<div><a id="app_help"></a><p><strong>release-batch-dlupd</strong> [<em>OPTION</em>]...</p>
<h3>OPTIONS</h3>
<p><code><strong>--create</strong>=<em>ARG</em></code></p>
<p><code><strong>--ghcli</strong>=<em>ARG</em></code></p>
<p><code><strong>--list</strong>=<em>ARG</em></code></p>
<p><code><strong>--root</strong>=<em>ARG</em></code></p>
<p><code><strong>--update</strong>=<em>ARG</em></code></p>
<h3>DETAILS</h3>
<p>Shorthand (bools): <code><strong>--OPT</strong></code> is <code><strong>--OPT</strong>=<em>true</em></code>, <code><strong>--no-OPT</strong></code> is <code><strong>--OPT</strong>=<em>false</em></code></p>
<table>
<tr><th><code><strong>--help</strong></code>, <code><strong>-h</strong></code></th>
<td>
<p>this help ("-?": show defaults)</p>
</td></tr>
<tr><th><code><strong>--root</strong>=<em>ROOT</em></code></th>
<td>
<p>all configs (per-package &amp; global) + downloads</p>
</td></tr>
<tr><th><code><strong>--create</strong>=<em>URL</em></code></th>
<td>
<p>URL / "true"; creates ROOT first if inexistent.</p>
</td></tr>
<tr><th><code><strong>--update</strong>=<em>PKG</em></code></th>
<td>
<p>true (all) / false / PKG subdir path (abs. / relative to ROOT)</p>
</td></tr>
</table>
<p>ROOT default: my dirname (if I was invoked through a symlink: target's dirname)</p>
<h4>URL (<code>--create</code>):</h4>
<table>
<tr><th><code>https://github.com/OWNER/NAME/releases/latest</code></th>
<td>
<p>latest release</p>
</td></tr>
<tr><th><code>https://github.com/OWNER/NAME/releases/tag/TAG</code></th>
<td>
<p>specific release</p>
</td></tr>
<tr><th>true</th>
<td>
<p>this package</p>
</td></tr>
</table>
<p><code><strong>--create</strong>[=<em>true</em>]</code> configures a package subdir for my latest release, updates &amp; symlinks <code>ROOT/op</code> to my latest version (i.e. <code>ROOT/op</code> implies <code><strong>--root</strong>=<em>ROOT</em></code>).</p>
<h3>PACKAGE SUBDIRS</h3>
<p>Register packages by creating <code>ROOT/p/PKG</code> subdirs, where PKG is the download URL (no https). <code><strong>--create</strong>=<em>https://...</em></code> does so automatically (see patterns above; view the results of <code><strong>--create</strong>[=<em>true</em>]</code>). Within a subdir:</p>
<table>
<tr><th><code>%cfg%/</code></th>
<td>
<p>configure downloads (presence identifies a package subdir)</p>
</td></tr>
<tr><th><code>%dl%/</code></th>
<td>
<p>downloaded assets</p>
</td></tr>
<tr><th><code>%state%/</code></th>
<td>
<p>current package version etc. Wipe it (<code>rm <strong>-rf</strong></code>) to reset.</p>
</td></tr>
</table>
<h4>Config files (<code>%cfg%/*</code>):</h4>
<table>
<tr><th><code>asset/glob.txt</code></th>
<td>
<p>one pattern / line.</p>
</td></tr>
<tr><th><code>bin/preupd</code></th>
<td>
<p>runs once per package when updates found</p>
</td></tr>
<tr><th><code>bin/postupd</code></th>
<td>
<p>runs when downloads complete</p>
</td></tr>
</table>
<h4>Default scripts (<code>--create</code>):</h4>
<table>
<tr><th>preupd</th>
<td>
<p><code>rm <strong>-rf</strong> %dl%/*</code> (<code><strong>--update</strong></code> skips existing!)</p>
</td></tr>
<tr><th>postupd</th>
<td>
<p><code>chmod a+x %dl%/*</code> (too broad but simple)</p>
</td></tr>
</table>
<a id="app_help_end"></a></div>

## Copyright

Alin Mr. (almr.oss at outlook.com) / MIT license
