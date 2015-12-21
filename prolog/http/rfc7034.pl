:- module(
  rfc7034,
  [
    'RWS'//0,
    'x-frame-options'//1 % -Value
  ]
).

/** <module> RFC 7034: HTTP Header Field X-Frame-Options

@author Wouter Beek
@compat RFC 7034
@see https://tools.ietf.org/html/rfc7034
@version 2015/12
*/

:- use_module(library(dcg/dcg_ext)).
:- use_module(library(dcg/rfc2234)).
:- use_module(library(http/rfc6454)).





%! 'RWS'// .
% ```abnf
% RWS = 1*( SP / HTAB )
% ```

'RWS' --> +('SP' ; 'HTAB').



%! 'x-frame-options'(-Value)// .
% ```abnf
% X-Frame-Options = "DENY"
%                   / "SAMEORIGIN"
%                   / ( "ALLOW-FROM" RWS SERIALIZED-ORIGIN )
% ```
%
% The following values are supported:
%   * `DENY'
%   * `SAMEORIGIN'
%   * `ALLOW-FROM'
%     Followed by a serialized-origin [RFC6454].

'x-frame-options'(deny) --> "DENY".
'x-frame-options'(sameorigin) --> "SAMEORIGIN".
'x-frame-options'(Origin) --> "ALLOW-FROM", 'RWS', 'serialized-origin'(Origin).
