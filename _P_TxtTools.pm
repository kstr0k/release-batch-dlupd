package _P_TxtTools;
use warnings; use v5.28;
use re '/a';
use parent 'Exporter';
our @EXPORT = qw(file_new_or_die slurp_fh slurp_fname splice1_chk split_section esc_html html_tag_h_demote html_tag_unwrap html_tag_merge html_tag_unnest html_tag_dl_to_table);

our $notag_rx = qr{[^<]*?};
our $html_space_rx = qr{[&]nbsp;|\p{SpacePerl}};

sub file_new_or_die {
  die if 0 == @_;
  $_[ 1 ] //= '< :encoding(UTF-8)';
  my $fh = IO::File->new( @_ );
  die $! unless defined $fh;
  return $fh;
}

sub slurp_fh {
  # don't rely on ($fh) = @_ being undef: failed, unchecked open()'s also produce undef's
  my $fh = (0 == @_) ? \*STDIN : shift;
  local $/; return do { <$fh> };
}
sub slurp_fname {
  use autodie;  # only open(), not IO::File
  return slurp_fh( file_new_or_die @_ );
}

sub split_section {
  my ($in, $beg_rx, $end_rx) = @_;
  # split(): capture group -> delimiters generate fields too (but they don't count toward LIMIT)
  my @parts = split( qr{($beg_rx)}, $in, 2 );
  my $nparts = 0 + @parts;
  if (2 <= $nparts and defined $end_rx) {
    die unless $nparts >= 3;
    my @end_parts = split( qr{($end_rx)}, $parts[ $nparts - 1 ], 2 );
    1 == @end_parts or splice @parts, $nparts - 1, 1, @end_parts;  # optimization
  }
  return @parts;
}

# splice 1 item in list; return TRUE if modified
sub splice1_chk {
  my ($list_ref, $splice_at, $new) = @_;
  return 0 if $new eq @$list_ref[ $splice_at ];
  splice @$list_ref, $splice_at, 1, $new;
  return 1;
}

# subs work on $_ when called in void context, otherwise on initial $html arg

sub esc_html {
  my $html = defined wantarray ? shift : $_;
  $html =~ s!&!\&amp;!g;  # ampersands first
  $html =~ s!<!\&lt;!g;
  $html =~ s!>!\&gt;!g;   # ^ just for symmetry ('>' needs no escaping)
  $_ = $html unless defined wantarray; return $html;
}

sub html_tag_h_demote {
  my $html = defined wantarray ? shift : $_;
  my $n = shift;
  $html =~ s{<(/?)h(\d+)>}{q(<) . $1 . q(h) . ($2 + $n) . q(>)}ge;
  $_ = $html unless defined wantarray; return $html;
}

sub html_tag_strip {
  my $html = defined wantarray ? shift : $_;
  my $tag_rx = shift;
  $html =~ s{</?($tag_rx)>}{}g;
  $_ = $html unless defined wantarray; return $html;
}

sub html_tag_merge {
  my $html = defined wantarray ? shift : $_;
  my $tag = quotemeta( shift );
  $html =~ s{</$tag>($html_space_rx*)<$tag>}{$1}g;
  $_ = $html unless defined wantarray; return $html;
}

sub html_tag_unnest {
  #use re 'debug';
  my $html = defined wantarray ? shift : $_;
  my ($t1, $t2) = map { quotemeta } @_;
  my $skip_verb2 = $t1 eq $t2 ? '' : '(*SKIP)';
  my $nested_rx = qr{
    (?<= <$t1>)
    (?<b4> .*?) < (?: /$t1>(*SKIP)(*F)|$t2>)
    (?# allow <t><t><t> retry at second match)
    (?<in> .*?) < (?: $t2>$skip_verb2(*F)|/$t2>)
  }x;
  while (1) {
    my $m = 0;
    $m ||= ( $html =~ s{$nested_rx}{$+{b4}$+{in}}g );
    last unless $m;
  }
  $_ = $html unless defined wantarray; return $html;
}

sub html_tag_dl_to_table {
  my $html = defined wantarray ? shift : $_;
  $html =~ s{<(/?)dl>}{<$1table>}g;
  $html =~ s{<dt>}{<tr><th>}g;
  $html =~ s{</dt>}{</th>}g;
  $html =~ s{<dd>}{<td>}g;
  $html =~ s{</dd>}{</td></tr>}g;
  $_ = $html unless defined wantarray; return $html;
}

1;
