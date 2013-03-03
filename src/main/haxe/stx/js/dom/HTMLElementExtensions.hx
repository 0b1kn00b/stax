/*
 HaXe library written by Paul M. De Goes <paul@socialmedia.com> and John A. De Goes <john@socialmedia.com>

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the
 distribution.

 THIS SOFTWARE IS PROVIDED BY SOCIAL MEDIA NETWORKS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SOCIAL MEDIA NETWORKS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package stx.js.dom;

import stx.Prelude;
import stx.js.Dom;

using stx.Arrays;

using stx.js.dom.HTMLDocumentExtensions;
using stx.js.dom.DomExtensions.DomCollectionExtensions;

using stx.Maybes;

class HTMLElementExtensions {
  
  public static function hasClass(e: HTMLElement, name: String): Bool {
    return e.getAttribute('class').split(" ").exists(function(e) { return e == name; });
  }
  
  public static function removeElement(e: HTMLElement): Void {
    var parent = e.parentNode;
    if (parent != null) {
      parent.removeChild(e);
    }
  }
  
  public static function getTags(e: HTMLElement, tagName: String): Array<HTMLElement> {
    return e.getElementsByTagName(tagName).toArray();
  }
  
  public static function add(e: HTMLElement, child: HTMLElement): HTMLElement {
    e.appendChild(child);
    return e;
  }
  
  public static function setAttr(e: HTMLElement, attGet: String, attSet: String): HTMLElement {
    e.setAttribute(attGet, attSet);
    return e;
  }
  
  public static function getAttr(e: HTMLElement, attGet: String): String {
    return e.getAttribute(attGet);
  }
  
  public static function setClass(e: HTMLElement, className: String):HTMLElement {
    e.className = className;
    return e;
  }
  

// ************************  As Element Functions
  
  public static inline function asIframe(e: HTMLElement): HTMLIFrameElement {
    return asIframeMaybe(e).get();
  }
  
  public static inline function asScript(e: HTMLElement): HTMLScriptElement {
    return asScriptMaybe(e).get();
  }
  
  public static inline function asDiv(e: HTMLElement): HTMLDivElement {
    return asDivMaybe(e).get();
  }
  
  public static inline function asForm(e: HTMLElement): HTMLFormElement {
    return asFormMaybe(e).get();
  }
  
  public static inline function asBody(e: HTMLElement): HTMLBodyElement {
    return asBodyMaybe(e).get();
  }
  
  public static inline function asStyle(e: HTMLElement): HTMLStyleElement {
    return asStyleMaybe(e).get();
  }

  public static inline function asText(e: HTMLElement): HTMLTextElement {
    return asTextMaybe(e).get();
  }
  
  public static inline function asVideo(e: HTMLElement): HTMLVideoElement {
    return asVideoMaybe(e).get();
  }
  
  public static inline function asAudio(e: HTMLElement): HTMLAudioElement {
    return asAudioMaybe(e).get();
  }
  
  public static inline function asHead(e: HTMLElement): HTMLHeadElement {
    return asHeadMaybe(e).get();
  }
  
  public static inline function asLink(e: HTMLElement): HTMLLinkElement {
    return asLinkMaybe(e).get();
  }
  
  public static inline function asTitle(e: HTMLElement): HTMLTitleElement {
    return asTitleMaybe(e).get();
  }
  
  public static inline function asMeta(e: HTMLElement): HTMLMetaElement {
    return asMetaMaybe(e).get();
  }
  
  public static inline function asBase(e: HTMLElement): HTMLBaseElement {
    return asBaseMaybe(e).get();
  }
  
  public static inline function asIsIndex(e: HTMLElement): HTMLIsIndexElement {
    return asIsIndexMaybe(e).get();
  }
  
  public static inline function asSelect(e: HTMLElement): HTMLSelectElement {
    return asSelectMaybe(e).get();
  }
  
  public static inline function asCanvas(e: HTMLElement): HTMLCanvasElement {
    return asCanvasMaybe(e).get();
  }
  
  public static inline function asOptGroup(e: HTMLElement): HTMLOptGroupElement {
    return asOptGroupMaybe(e).get();
  }
  
  public static inline function asMaybe(e: HTMLElement): HTMLMaybeElement {
    return asMaybeMaybe(e).get();
  }
  
  public static inline function asInput(e: HTMLElement): HTMLInputElement {
    return asInputMaybe(e).get();
  }
  
  public static inline function asTextArea(e: HTMLElement): HTMLTextAreaElement {
    return asTextAreaMaybe(e).get();
  }
  
  public static inline function asButton(e: HTMLElement): HTMLButtonElement {
    return asButtonMaybe(e).get();
  }
  
  public static inline function asLabel(e: HTMLElement): HTMLLabelElement {
    return asLabelMaybe(e).get();
  }
  
  public static inline function asFieldSet(e: HTMLElement): HTMLFieldSetElement {
    return asFieldSetMaybe(e).get();
  }
  
  public static inline function asLegend(e: HTMLElement): HTMLLegendElement {
    return asLegendMaybe(e).get();
  }
  
  public static inline function asUList(e: HTMLElement): HTMLUListElement {
    return asUListMaybe(e).get();
  }
  
  public static inline function asOList(e: HTMLElement): HTMLOListElement {
    return asOListMaybe(e).get();
  }
  
  public static inline function asDList(e: HTMLElement): HTMLDListElement {
    return asDListMaybe(e).get();
  }
  
  public static inline function asDir(e: HTMLElement): HTMLDirectoryElement {
    return asDirMaybe(e).get();
  }
  
  public static inline function asMenu(e: HTMLElement): HTMLMenuElement {
    return asMenuMaybe(e).get();
  }
  
  public static inline function asLI(e: HTMLElement): HTMLLIElement {
    return asLIMaybe(e).get();
  }
  
  public static inline function asP(e: HTMLElement): HTMLParagraphElement {
    return asPMaybe(e).get();
  }
  
  public static inline function asH(e: HTMLElement): HTMLHeadingElement {
    return asHMaybe(e).get();
  }
  
  public static inline function asQuote(e: HTMLElement): HTMLQuoteElement {
    return asQuoteMaybe(e).get();
  }
  
  public static inline function asPre(e: HTMLElement): HTMLPreElement {
    return asPreMaybe(e).get();
  }
  
  public static inline function asBR(e: HTMLElement): HTMLBRElement {
    return asBRMaybe(e).get();
  }
  
  public static inline function asBaseFont(e: HTMLElement): HTMLBaseFontElement {
    return asBaseFontMaybe(e).get();
  }
  
  public static inline function asFont(e: HTMLElement): HTMLFontElement {
    return asFontMaybe(e).get();
  }
  
  public static inline function asHR(e: HTMLElement): HTMLHRElement {
    return asHRMaybe(e).get();
  }
  
  public static inline function asMod(e: HTMLElement): HTMLModElement {
    return asModMaybe(e).get();
  }
  
  public static inline function asA(e: HTMLElement): HTMLAnchorElement {
    return asAMaybe(e).get();
  }
  
  public static inline function asImage(e: HTMLElement): HTMLImageElement {
    return asImageMaybe(e).get();
  }
  
  public static inline function asObject(e: HTMLElement): HTMLObjectElement {
    return asObjectMaybe(e).get();
  }
  
  public static inline function asParam(e: HTMLElement): HTMLParamElement {
    return asParamMaybe(e).get();
  }
  
  public static inline function asApplet(e: HTMLElement): HTMLAppletElement {
    return asAppletMaybe(e).get();
  }
  
  public static inline function asMap(e: HTMLElement): HTMLMapElement {
    return asMapMaybe(e).get();
  }
  
  public static inline function asArea(e: HTMLElement): HTMLAreaElement {
    return asAreaMaybe(e).get();
  }
  
  public static inline function asTable(e: HTMLElement): HTMLTableElement {
    return asTableMaybe(e).get();
  }
  
  public static inline function asCaption(e: HTMLElement): HTMLTableCaptionElement {
    return asCaptionMaybe(e).get();
  }
  
  public static inline function asTD(e: HTMLElement): HTMLTableColElement {
    return asTDMaybe(e).get();
  }
  
  public static inline function asTHead(e: HTMLElement): HTMLTableSectionElement {
    return asTHeadMaybe(e).get();
  }
  
  public static inline function asTBody(e: HTMLElement): HTMLTableSectionElement {
    return asTBodyMaybe(e).get();
  }
  
  public static inline function asTFoot(e: HTMLElement): HTMLTableSectionElement {
    return asTFootMaybe(e).get();
  }
  
  public static inline function asTR(e: HTMLElement): HTMLTableRowElement {
    return asTRMaybe(e).get();
  }
  
  public static inline function asFrameSet(e: HTMLElement): HTMLFrameSetElement {
    return asFrameSetMaybe(e).get();
  }
  
  public static inline function asFrame(e: HTMLElement): HTMLFrameElement {
    return asFrameMaybe(e).get();
  }
  
  public static inline function asIFrame(e: HTMLElement): HTMLIFrameElement {
    return asIFrameMaybe(e).get();
  }
  
  
  
// ************************ As Element Maybe Functions

  public static inline function asIframeMaybe(e: HTMLElement): Maybe<HTMLIFrameElement> {
    return if (e.nodeName == 'IFRAME') Some(cast e); else None;
  }
  
  public static inline function asScriptMaybe(e: HTMLElement): Maybe<HTMLScriptElement> {
    return if (e.nodeName == 'SCRIPT') Some(cast e); else None;
  }
  
  public static inline function asDivMaybe(e: HTMLElement): Maybe<HTMLDivElement> {
    return if (e.nodeName == 'DIV') Some(cast e); else None;
  }
  
  public static inline function asFormMaybe(e: HTMLElement): Maybe<HTMLFormElement> {
    return if (e.nodeName == 'FORM') Some(cast e); else None;
  }
  
  public static inline function asBodyMaybe(e: HTMLElement): Maybe<HTMLBodyElement> {
    return if (e.nodeName == 'BODY') Some(cast e); else None;
  }
  
  public static inline function asStyleMaybe(e: HTMLElement): Maybe<HTMLStyleElement> {
    return if (e.nodeName == 'STYLE') Some(cast e); else None;
  }

  public static inline function asTextMaybe(e: HTMLElement): Maybe<HTMLTextElement> {
    return if (e.nodeName == 'TEXT') Some(cast e); else None;
  }
  
  public static inline function asVideoMaybe(e: HTMLElement): Maybe<HTMLVideoElement> {
    return if (e.nodeName == 'VIDEO') Some(cast e); else None;
  }
  
  public static inline function asAudioMaybe(e: HTMLElement): Maybe<HTMLAudioElement> {
    return if (e.nodeName == 'AUDIO') Some(cast e); else None;
  }
  
  public static inline function asHeadMaybe(e: HTMLElement): Maybe<HTMLHeadElement> {
    return if (e.nodeName == 'HEAD') Some(cast e); else None;
  }
  
  public static inline function asLinkMaybe(e: HTMLElement): Maybe<HTMLLinkElement> {
    return if (e.nodeName == 'LINK') Some(cast e); else None;
  }
  
  public static inline function asTitleMaybe(e: HTMLElement): Maybe<HTMLTitleElement> {
    return if (e.nodeName == 'TITLE') Some(cast e); else None;
  }
  
  public static inline function asMetaMaybe(e: HTMLElement): Maybe<HTMLMetaElement> {
    return if (e.nodeName == 'META') Some(cast e); else None;
  }
  
  public static inline function asBaseMaybe(e: HTMLElement): Maybe<HTMLBaseElement> {
    return if (e.nodeName == 'BASE') Some(cast e); else None;
  }
  
  public static inline function asIsIndexMaybe(e: HTMLElement): Maybe<HTMLIsIndexElement> {
    return if (e.nodeName == 'ISINDEX') Some(cast e); else None;
  }
  
  public static inline function asSelectMaybe(e: HTMLElement): Maybe<HTMLSelectElement> {
    return if (e.nodeName == 'SELECT') Some(cast e); else None;
  }
  
  public static inline function asCanvasMaybe(e: HTMLElement): Maybe<HTMLCanvasElement> {
    return if (e.nodeName == 'CANVAS') Some(cast e); else None;
  }
  
  public static inline function asOptGroupMaybe(e: HTMLElement): Maybe<HTMLOptGroupElement> {
    return if (e.nodeName == 'OPTGROUP') Some(cast e); else None;
  }
  
  public static inline function asMaybeMaybe(e: HTMLElement): Maybe<HTMLMaybeElement> {
    return if (e.nodeName == 'OPTION') Some(cast e); else None;
  }
  
  public static inline function asInputMaybe(e: HTMLElement): Maybe<HTMLInputElement> {
    return if (e.nodeName == 'INPUT') Some(cast e); else None;
  }
  
  public static inline function asTextAreaMaybe(e: HTMLElement): Maybe<HTMLTextAreaElement> {
    return if (e.nodeName == 'TEXTAREA') Some(cast e); else None;
  }
  
  public static inline function asButtonMaybe(e: HTMLElement): Maybe<HTMLButtonElement> {
    return if (e.nodeName == 'BUTTON') Some(cast e); else None;
  }
  
  public static inline function asLabelMaybe(e: HTMLElement): Maybe<HTMLLabelElement> {
    return if (e.nodeName == 'LABEL') Some(cast e); else None;
  }
  
  public static inline function asFieldSetMaybe(e: HTMLElement): Maybe<HTMLFieldSetElement> {
    return if (e.nodeName == 'FIELDSET') Some(cast e); else None;
  }
  
  public static inline function asLegendMaybe(e: HTMLElement): Maybe<HTMLLegendElement> {
    return if (e.nodeName == 'LEGEND') Some(cast e); else None;
  }
  
  public static inline function asUListMaybe(e: HTMLElement): Maybe<HTMLUListElement> {
    return if (e.nodeName == 'UL') Some(cast e); else None;
  }
  
  public static inline function asOListMaybe(e: HTMLElement): Maybe<HTMLOListElement> {
    return if (e.nodeName == 'OL') Some(cast e); else None;
  }
  
  public static inline function asDListMaybe(e: HTMLElement): Maybe<HTMLDListElement> {
    return if (e.nodeName == 'DL') Some(cast e); else None;
  }
  
  public static inline function asDirMaybe(e: HTMLElement): Maybe<HTMLDirectoryElement> {
    return if (e.nodeName == 'DIR') Some(cast e); else None;
  }
  
  public static inline function asMenuMaybe(e: HTMLElement): Maybe<HTMLMenuElement> {
    return if (e.nodeName == 'MENU') Some(cast e); else None;
  }
  
  public static inline function asLIMaybe(e: HTMLElement): Maybe<HTMLLIElement> {
    return if (e.nodeName == 'LI') Some(cast e); else None;
  }
  
  public static inline function asPMaybe(e: HTMLElement): Maybe<HTMLParagraphElement> {
    return if (e.nodeName == 'P') Some(cast e); else None;
  }
  
  public static inline function asHMaybe(e: HTMLElement): Maybe<HTMLHeadingElement> {
    return if (e.nodeName == 'H') Some(cast e); else None;
  }
  
  public static inline function asQuoteMaybe(e: HTMLElement): Maybe<HTMLQuoteElement> {
    return if (e.nodeName == 'QUOTE') Some(cast e); else None;
  }
  
  public static inline function asPreMaybe(e: HTMLElement): Maybe<HTMLPreElement> {
    return if (e.nodeName == 'PRE') Some(cast e); else None;
  }
  
  public static inline function asBRMaybe(e: HTMLElement): Maybe<HTMLBRElement> {
    return if (e.nodeName == 'BR') Some(cast e); else None;
  }
  
  public static inline function asBaseFontMaybe(e: HTMLElement): Maybe<HTMLBaseFontElement> {
    return if (e.nodeName == 'BASEFONT') Some(cast e); else None;
  }
  
  public static inline function asFontMaybe(e: HTMLElement): Maybe<HTMLFontElement> {
    return if (e.nodeName == 'FONT') Some(cast e); else None;
  }
  
  public static inline function asHRMaybe(e: HTMLElement): Maybe<HTMLHRElement> {
    return if (e.nodeName == 'HR') Some(cast e); else None;
  }
  
  public static inline function asModMaybe(e: HTMLElement): Maybe<HTMLModElement> {
    return if (e.nodeName == 'MOD') Some(cast e); else None;
  }
  
  public static inline function asAMaybe(e: HTMLElement): Maybe<HTMLAnchorElement> {
    return if (e.nodeName == 'A') Some(cast e); else None;
  }
  
  public static inline function asImageMaybe(e: HTMLElement): Maybe<HTMLImageElement> {
    return if (e.nodeName == 'IMG') Some(cast e); else None;
  }
  
  public static inline function asObjectMaybe(e: HTMLElement): Maybe<HTMLObjectElement> {
    return if (e.nodeName == 'OBJECT') Some(cast e); else None;
  }
  
  public static inline function asParamMaybe(e: HTMLElement): Maybe<HTMLParamElement> {
    return if (e.nodeName == 'PARAM') Some(cast e); else None;
  }
  
  public static inline function asAppletMaybe(e: HTMLElement): Maybe<HTMLAppletElement> {
    return if (e.nodeName == 'APPLET') Some(cast e); else None;
  }
  
  public static inline function asMapMaybe(e: HTMLElement): Maybe<HTMLMapElement> {
    return if (e.nodeName == 'MAP') Some(cast e); else None;
  }
  
  public static inline function asAreaMaybe(e: HTMLElement): Maybe<HTMLAreaElement> {
    return if (e.nodeName == 'AREA') Some(cast e); else None;
  }
  
  public static inline function asTableMaybe(e: HTMLElement): Maybe<HTMLTableElement> {
    return if (e.nodeName == 'TABLE') Some(cast e); else None;
  }
  
  public static inline function asCaptionMaybe(e: HTMLElement): Maybe<HTMLTableCaptionElement> {
    return if (e.nodeName == 'CAPTION') Some(cast e); else None;
  }
  
  public static inline function asTDMaybe(e: HTMLElement): Maybe<HTMLTableColElement> {
    return if (e.nodeName == 'TD') Some(cast e); else None;
  }
  
  public static inline function asTHeadMaybe(e: HTMLElement): Maybe<HTMLTableSectionElement> {
    return if (e.nodeName == 'THEAD') Some(cast e); else None;
  }
  
  public static inline function asTBodyMaybe(e: HTMLElement): Maybe<HTMLTableSectionElement> {
    return if (e.nodeName == 'TBODY') Some(cast e); else None;
  }
  
  public static inline function asTFootMaybe(e: HTMLElement): Maybe<HTMLTableSectionElement> {
    return if (e.nodeName == 'TFOOT') Some(cast e); else None;
  }
  
  public static inline function asTRMaybe(e: HTMLElement): Maybe<HTMLTableRowElement> {
    return if (e.nodeName == 'TR') Some(cast e); else None;
  }
  
  public static inline function asFrameSetMaybe(e: HTMLElement): Maybe<HTMLFrameSetElement> {
    return if (e.nodeName == 'FRAMESET') Some(cast e); else None;
  }
  
  public static inline function asFrameMaybe(e: HTMLElement): Maybe<HTMLFrameElement> {
    return if (e.nodeName == 'FRAME') Some(cast e); else None;
  }
  
  public static inline function asIFrameMaybe(e: HTMLElement): Maybe<HTMLIFrameElement> {
    return if (e.nodeName == 'IFRAME') Some(cast e); else None;
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}