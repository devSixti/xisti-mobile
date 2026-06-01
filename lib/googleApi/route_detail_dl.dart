class RouteDetailPojo {
  RouteDetailPojo({this.routes});

  RouteDetailPojo.fromJson(dynamic json) {
    if (json['routes'] != null) {
      routes = [];
      json['routes'].forEach((v) {
        routes?.add(Routes.fromJson(v));
      });
    }
  }

  List<Routes>? routes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (routes != null) {
      map['routes'] = routes?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// legs : [{"steps":[{"navigationInstruction":{"maneuver":"DEPART","instructions":"Head east toward Serenity Garden Rd"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right onto Serenity Garden Rd\nPass by Serenity Garden (on the left)"}},{"navigationInstruction":{"maneuver":"TURN_LEFT","instructions":"Turn left at Shree Ravi Randal Temple onto Kalavad Rd/Rajkot Rd\nPass by LAUGH A LATTE (on the left)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right at Bombay auto onto 2nd Ring Rd\nPass by Solanki Eggs Santor (on the right)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right onto NH 27\nToll road\nPass by KHODIYAR AUTO (on the left in 3.1 km)"}},{"navigationInstruction":{"maneuver":"TURN_SLIGHT_LEFT","instructions":"Slight left\nPass by Shree Mahavir Courier Services Pvt Ltd (on the left in 900m)"}},{"navigationInstruction":{"maneuver":"MERGE","instructions":"Merge onto NH 27\nPass by Shivalaya no 2 (on the right in 1.6 km)"}},{"navigationInstruction":{"maneuver":"TURN_SLIGHT_LEFT","instructions":"Slight left toward Service Rd"}},{"navigationInstruction":{"maneuver":"NAME_CHANGE","instructions":"Continue onto Service Rd\nPass by Hyundai Gondal (Shiv) (on the left)"}},{"navigationInstruction":{"maneuver":"TURN_SLIGHT_RIGHT","instructions":"Slight right toward NH 27"}},{"navigationInstruction":{"maneuver":"MERGE","instructions":"Merge onto NH 27\nPass by Shree Tejashvi Hanuman & Shree Shanidev Temple (on the left in 750m)"}},{"navigationInstruction":{"maneuver":"TURN_LEFT","instructions":"Turn left at Trishul tyre\nPass by ASHIRWAD AUTO PARTS (on the right)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right at Gundala Chowkdi onto Gondal - Jamkandorana Rd/Gundala Rd\nContinue to follow Gondal - Jamkandorana Rd\nPass by Ambaji Mandir & Murti Bhandar (on the right)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right\nPass by શિર્વારા વેબ્રીજ (on the left)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right at NOVELT POLYMERS®"}},{"navigationInstruction":{"maneuver":"TURN_LEFT","instructions":"Turn left\nPass by Flowmark Polyplast PVT.LTD. (on the right)"}},{"navigationInstruction":{"maneuver":"TURN_LEFT","instructions":"Turn left"}},{"navigationInstruction":{"maneuver":"TURN_LEFT","instructions":"Turn left\nPass by શિર્વારા વેબ્રીજ (on the right in 700m)"}},{"navigationInstruction":{"maneuver":"TURN_LEFT","instructions":"Turn left onto Gondal - Jamkandorana Rd\nPass by the gas station (on the right)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right\nPass by સોનાપુરી (સ્મસાન) ગુંદાળા (on the right)"}},{"navigationInstruction":{"maneuver":"TURN_LEFT","instructions":"Turn left at S T. Dhol Highschool Library onto Patidad Rd\nPass by Bajrang Enterprise (on the left)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right to stay on Patidad Rd\nPass by Kanaiya tea stall & ice cream (on the right in 3.1 km)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right at GOMTA FATAK onto NH 27\nToll road\nPass by Gomta chowkadi (on the left)"}},{"navigationInstruction":{"maneuver":"TURN_SLIGHT_LEFT","instructions":"Slight left at Khodal gathiya onto NH151\nPass by G N D Electronics (on the right in 850m)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right at Mangal Bishi onto Junagadh Byp\nPass by Raysingh Rawat (on the left in 5 km)"}},{"navigationInstruction":{"maneuver":"TURN_SHARP_LEFT","instructions":"Sharp left"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right\nPass by Jagani Temple (on the left in 500m)"}},{"navigationInstruction":{"maneuver":"NAME_CHANGE","instructions":"Continue onto Zanzarda Rd\nPass by Indian pan and provision store (on the left in 450m)\nDestination will be on the left"}}]}]
/// distanceMeters : 117212
/// duration : "9822s"
/// polyline : {"encodedPolyline":"sh}fCeewnLGy@`@?dADf@@\\BD?|ADr@BV?P?b@?rBQ`AGx@ElAIO_AWiDY_EWyDK}AI{@KgBIoAW}DOyA?_@RMd@a@t@g@h@_@NGDCJAHGXUJGf@YLKfAu@bBkAPMPK`Ao@xAaAtBuAt@g@`Ao@rAy@`Ao@t@g@j@_@`BiA`CaBpBqAz@w@HINIdBqAvAcAfCeB|@g@fBoA`As@jA}@NIrCsBvA}@LGzA]|AQxAMRCr@G~@Gj@C|@GTEZELCREfAWXGxASd@GfCKrBBdBHP@F?bBNP@P@b@Bj@BXB`@BlBBF?nB?rC@~@BD?|@AnAMjAQ`AQrASvB[nAQj@IZIdBe@dAc@LE|@_@bBs@d@ShAe@`Bw@r@[bAa@zD_BrB}@j@O`A]ZGhBc@`@KhAY|@UhAYHCl@OnBg@n@Or@QrAa@TI`EiBpFaC^QZMbAe@^O~BeA`EiBzAq@fBs@`CaAn@c@zB_A^Q`DuAl@SzDuA`C}@`A]b@Q\\M|@]pAi@x@YLCl@Ud@O^OrDsAxFsBfAc@nC}@dAc@`@MREz@OF?`@Er@I|@I^?XAfAIREXKXIFClP{G|CuApI_Fl@[XQhAw@`HsDxAo@~K}D~@YpIyCbDqA`DgAfC}@jC_AVKTKTKJEJEzAq@zAq@hCgAdDsAHEHEFAdCiAx@]~@a@fDuAzAq@`Aa@DAXM^Qx@a@rB{@h@a@~A}AdAaAd@a@NWNa@Ns@`@oBX{ALs@Bi@A{C@eCEsECuA?aC?}@?{ACcEAw@C{BAy@EwEIeEAqAA_ACwECwE?EUyPC_C?gACI?EAG?G?O?EA[AMCWCWCSCSAUV@l@D~AD|AFjADpADtAFtBFrAFr@@~@B^@r@D~ABjADxBFlBDdDJT?rAFT@f@@pBD`BFd@Dh@DZ@h@BjAB~AHX@pDRD?f@Dn@Jx@TZLXLv@^n@Vd@VNH^TPHB@LFVJVHTFXFNBPBh@H`@F`Gn@l@Fx@L~AVPBb@FzC`@rC^\\DD@|@JlBXhAPVDRBpB\\`Dh@pAP|Cb@l@J~A`@|A\\pAXrBb@fB^XFr@PlCh@~A\\xBf@|AZlFdAbB^dCj@j@JdATbARNBdEx@dE~@tAZdDn@fARdATn@JXFf@JRDLBn@Ln@LNDLBbARb@HXDZF~AZlBZnBXdDh@l@JtBTb@DXBTBp@FrBN|AJvBNnCLzCRrALv@FxBRzAPb@D`@DRB~ARn@HdCXv@Hb@FhAL\\D|ARVBxANz@JdAHjALX@p@D^Bj@D`@@zBNtBL\\@j@B`@B`@@^DjAJb@D`@FL@l@Jh@JB?j@Lz@Pr@NVFZFTDJD|@VfAb@bBr@ZNx@Zf@T`@P\\N`@PRHJD`@P^N^PB@jAh@bAf@bAh@tAt@|Az@dAj@lAp@fAj@h@Zx@b@VL~Az@hAn@l@ZtAv@FBVNx@d@f@ZVPRNh@^b@\\lA`Aj@b@PLHH~@r@FDx@l@`@Z`@ZxAjAp@f@fBrAj@`@l@`@VNf@Vp@Zl@Rl@Tx@Rr@R\\HdAX|@RhB^jB\\NBLBNBvAXjBVr@JrARL@bAJn@Fz@@\\?Z?r@ArAEbAGvEUfBInBKpCIjAAt@?pCAV?fB?lB?Z?lCA|@AJ?bC?x@A`@Az@Cp@G`AKnC]fAMtAOn@Cl@GTCV?tBJdAHd@B`@DjAFxBJ|BP~BNpCRpBNd@@xBNfBL`CNr@D`@@d@?f@DPAT?Z?r@BfFD`A?nJJnC?pA?j@AnAIx@M~@OlBi@zCmAtBw@vJuDnBi@hCcAdDsAnDmAhDk@v@Gj@GbB?z@EPA`BKhAGb@ClAEv@E\\AdCMxAGnCOdBKfAI^AnAMjCMdBKhCMfESvCQpAIpBKnAG~@G`DQ`H_@hGc@t@EH?HAlCKtDUVCH?FAl@CnBKtLs@|BI~BMdDQfBI|Hc@t@ERAfCMrBKpAKH?H?fBIhBGtEWr@EvEWh@O\\CZA~AKpAG|@Gh@CpAId@CjAGjBKj@ClAI\\C~@Gp@C~@Gn@El@CdAGz@EbAGhAG~@G|@GdAGr@Ef@ETA|@Gt@Gf@BJ?^FXCHAh@Cj@C^CfAEr@EbCM^CzFYlCOn@CpBOtIc@xCQnFYzF[xEWpDQJAfAGxDSbBIbCOnBKx@Gl@Ej@AvAIhBKdBK|@GnAI|AGlBKxAIz@E~AIlAKh@GPExAQtAYr@QxCo@lAY^Gz@UD?vA[`@InCk@dDs@bASFAfE_AnDu@TEpBc@`B]dASjB_@LCnAYJCr@MhE}@`AUNCfD{@NCxA[bDq@xFoAXGv@Od@GJCrAWj@M|EeAfDu@@GHI`@IrBa@^IREHANCx@SvAYdAUjDw@h@MlCm@TEVGZGPEnEaA~A]v@QNChB_@fAUbAULE~A]f@M~Dw@fAUdAS~@Up@QdAUt@OPClAUxBg@vA[z@SbDs@TFZId@KdB]jB_@nBa@nCk@r@QdAUdBa@b@IdCk@^Id@K|@Md@EpAKF?p@?P@H?@CBABAB?BAB@B?@@BBJ@^DV@pBHf@FB?^F~@R`AT`AZb@Nh@Tt@^BBVP\\TDDj@`@TTXTp@p@d@f@v@v@XXvB|BPRlAnAr@t@BDRTjAjATTrBvBvA~AdBjBLLl@l@nArAhAlAFFf@f@dDpDn@n@pCzC^^hAnAn@t@FDLLl@l@pAtAv@t@l@f@j@\\HDd@Xj@`@pAx@zA~@fAt@v@j@rA|@pBrAfBnAbBfAxCpBvCnBjBnAz@x@`@VfAv@~@l@HDFDHDFDFDJEDADAH@TFr@X~@VdARL@r@Fh@DlAXPDxBj@Ef@CTEj@AHI`BCZEl@MhBCVC\\AR?RAV@`@@d@Bd@D|@DhAHbB@JF`BB\\@Z@NBb@DbAFzADjADdA?H@L?L@N?Z@j@@h@?j@@N?L?H@\\?R@J?D@P@F@HH~@PdBD`@ThBHn@XfCd@jE\\zCRdBF`@D\\PzAVtBBRHd@LdA@DVtBDZDh@@N@DB`@B`@D~@FfB?FF`BBx@Bx@@~A@H?Z?j@DvIB~C?j@?t@@f@?x@BjBBhA@N@ZBzABh@DbA?JBj@@JDdAJfC@TFxA?HBr@@T@XB`ABj@?L@D@\\?V?P?TARCf@ALC\\IfAALALAFC`@?DEXAJO~@APALANAv@AVCf@Gt@Gx@Gh@AHCVId@Kr@o@lDKd@i@zCI\\ENGRGPGLMXuApCcBdD_@t@a@x@eArB[n@OXMPKNMRa@h@[`@_@EkBF[?q@Ek@KqAWqBe@QEOEq@O_@E[CO@O@a@HYDM@_@?m@?eACqACG?[C[E[CKCD}EmBAqC?aAH@hE|@CrBET?T@VDXD\\DJ@JBZBZDZBF?pABdABl@?^?LAXE`@INANAZB^Dp@NNDPDpBd@pAVj@Jp@DV?nBG^DZa@`@i@LSJOLQNYZo@dAsB`@y@^u@bBeDtAqCLYFMFQFSDOH]h@{CJe@l@f@XVxEpDf@^nDpCzAjAh@^ZP~BhBdAt@VJf@N~ANb@F|ANNBJDB@HBDBHDVX\\b@BBHHhArAX\\HJPXN\\FVFLFLHJLLNNb@VLHZRHDPJ\\VRTFJHPJPZx@Zn@bAdCf@fAf@fAVj@Vx@Lr@Hv@B^T|D@Dd@dGN~CBdABnA@NA|BAzA?fF?DC`EAh@?X?vCB`AJ`AH~@RbBT~BPhBZ`DP`BDb@b@xE@B?LJ~BFlELbFBl@NdETbCx@zBHTb@pAHf@?`@?f@In@I~Ay@fHCTc@~DOnB?L@tADbA@JAr@OfAMt@ERMz@CNg@xCEt@@r@RWDE`@g@VGn@Eh@EB?l@GbAGt@Gz@CJA^AF?d@Ef@GjAOF?JCRCd@IBAVjAJ`@NRLEDA^QTOBCv@m@tAy@FE\\Qh@YNI^Q^OFCf@QVOHANEZET?~AA|CGT@vC@rCBJ@fD?D?vADV?Z@v@?pA@^B|BNz@Hl@DR@hBLD?nBNzCXpAN`CVPBpABh@CXCPAvBA`AJ^BpCZL@TDlDj@NBzEz@nC`@D@hAVf@TxAbApA~@v@|@d@j@dA|@j@d@h@h@r@f@JFtAd@|@VF@nAVh@Pt@N~@RNBPDdBZlBf@\\JRFN@dA@b@?F?xDBn@?lB?jA?bA@lA@hB@bB@f@EdBY`AO`Du@bB]BA|AYv@QpBaA~Aw@JGvAm@r@[\\Q^QvCqAfCkAtDgBhAg@zCuAZMBAZMjCsAtAo@vAm@f@Ut@[bBu@h@YhAk@l@Yn@_@v@m@t@s@fA_Ap@o@h@e@X]TYZc@`@k@FKP[b@u@Xm@Vk@j@oAb@}@DKFK`@{@jAeCP[Zk@RWn@q@f@m@f@m@|A_Bp@u@DGFGpAyAt@{@tAaBhAuAb@i@j@s@r@y@^g@JQFI@ELYLSVILD\\Nn@TtBx@PFrAh@`Ab@HHl@f@~@fAFHb@p@v@dAFFx@t@dA|@tAx@n@d@x@`ADBVPPH^TTLZPx@f@DBvAx@dDlBvAv@fEbC`CtAjAp@xDzBpAt@xA|@x@d@ZRDB|@h@h@Xj@\\tC`BTN`@Rv@b@t@b@b@Xb@Tj@Xn@Z^N^PRHRHZJJDLBXD`@FNB\\DXDb@HXFj@J~Ab@`AXt@R|Bl@r@Tj@PZHfA\\zBp@VFHBHB^JvBl@j@Nv@TVHTFzA`@|@XXJf@N`@NPFLDLHPHHFHDJF~@\\hD~@LDtBl@xCt@|EtALDJBRFtCx@rCr@bBb@~@V\\Jf@LdAVf@N\\JRFj@R^L`@NDBXJ\\PVP`@V\\Z\\ZZ^NPNRTZt@nAr@jAbAdBXh@pBhDT^x@rAlAtBJP\\j@`@p@d@x@hBzCtAbCbBlC~BzDbBrCnBfDxAfCZf@^r@j@v@NVb@d@PRf@b@XR\\Tx@`@t@Xv@Tv@Lp@Hn@@F?F@jABpCBbEFh@@\\@R?zAD|ADbEH\\@zABR?R?NAR?N?N@N?R@R@P?R@P?\\?^@X@`@@^@Z@\\?n@Bp@@`@@P@N?X@f@@\\?P?R?J?H@D@H@F@H?Z@ZB\\JPFPFRBVBxBBl@@`ABrA?l@CXC\\AL?F?T@VBbAJt@N~@VZH\\Jn@Vr@ZnAp@PJRL|D|Bv@b@rD~BjBlA`Ar@hI|Fb@ZdHdF`An@FDTP|AdAbI`GLJh@b@x@l@pAbAtAdAnEbDPJVTLJNJxAjAfA~@jAx@`@ZTRx@j@dAr@p@`@TLZRtBrAvBrAjEnCrBlA`BdAr@b@v@h@TPVTX\\NZtAvAfCdC|@z@LLn@l@bGdG~D|DhAjAbB~AHHHHfAhA`B|Aj@h@bCbCbA~@b@b@`AbAlAlAzAvAnBhBXZPTJJLJb@b@r@r@VR^X^Z`@VvAx@vAv@`Ah@v@^jB`AlCvAfAh@XNXT^Tn@\\p@b@^V~AjAJHBBbB|AVVhAjAr@z@\\\\`AfAVZj@l@n@t@h@l@t@z@z@bAX`@Z`@hApA`CxCt@x@\\b@VZVZBBZ`@d@l@`@h@V`@f@z@LZR\\DJLXJVXn@`@hAd@lA|@dC`@fAXhA@F?BAXAJ@Bf@|AN`@l@~A^dA^bAv@zBd@pANRVp@FRJVHRDHPZd@p@DDDF^Xb@Z`Ad@l@RNDD?RDNBJ@P@H?`@?b@A\\Eh@G|@IvASn@Ir@Gh@Ap@Cx@@X@JBN@ZLVJf@Tf@Vl@b@b@`@~AzA`AbA|AbB`AbADFlArAzBhCnAxAXZ`@d@b@f@p@v@f@j@z@bAxA~Ax@z@lApAr@t@zA~AHJ~DjEhAlAlDvDRTX\\HHxAdB~@hA`AhATVhAtAVXjArAbBlBdAhAvB`CRTXZXXXZh@j@tAzAfCpCxDhEHJh@l@b@f@b@f@`@b@d@p@f@t@Zj@JPXj@Xn@P\\JTDLl@`BZdAZpAF\\Jj@F\\Jl@\\lCHl@?BZ|BJv@Lx@RlALx@BT@LBLBRBPNhAFd@LjA@FF\\XnBNjADRBNLz@Ff@BTDl@Dh@@T@ZBtAA~BA~@AL?V?LAd@CbAIzFAhB?V?DAF?\\AfA?pACxA?t@?H@^?b@Bd@BXD^L`APx@Pp@\\fA\\t@^p@X`@HJX^v@z@TTBBlErElFnFXXDDRRXZJHLNvBtBfAhAx@|@DDFDLNBBVVBBHHfDhDf@h@XZ`DbD`FfFrBtBpCvCpBrBXXjAlAzE|EzBzB`B`BdC`CfBfB|A~AfAfAjAlARV`@b@^b@j@t@t@hABBp@fAd@|@l@pAj@~ATn@L`@HVDPBFFj@Jh@RRPP\\^VTRPb@XNHVLh@VtB~@ZPrB`AbAd@|BfALFdCjA|Av@|Av@rCpApAj@b@RdC`ApAj@zAf@^PjAh@`A^j@Tt@X^NxCfA~B`ATJVJzAp@XNt@Zf@XXPBBNHJFB@BBr@b@HDRLB@FDVPl@b@~@p@VPLJf@`@l@f@t@l@p@n@vChCfAz@FF`@\\JHRPJJ|@t@LHLHVR^Xj@`@TPXPTNJFxBtAXPhAr@l@^z@d@ZN`@PVHJD\\H\\HNBNDZDf@FV@R@V@\\?j@AXARAVCXEVEJAJCNEJCb@MDAFAJE`@ORK^Qp@c@VSd@[j@g@VSNKtAkAhA_AbDkCHGBA|@s@lB_BrBeBxBkBlB}Ah@a@~@y@nAcA`@]LKLIJKDCLMLIt@o@^Yn@c@XOd@Wj@UTKx@[jA]LCn@M|@Or@Gb@ED?b@Cd@AZ?X?j@@V?bAHtARVBHB`@Hh@JnA\\d@R~@`@j@XrA`Ab@^jBdBFFPPt@v@^`@f@h@^^d@h@dBhBHNdAfAjAnAzB~Bn@p@t@v@t@x@f@h@NNTTf@j@d@f@j@n@Z\\x@z@dAdAjAnA~A~An@j@z@v@p@l@RNPP`A|@v@p@r@p@x@t@ZVlEzDxArAvAnA~@x@FFFFZVlAdAb@b@|@t@j@f@f@`@xBlBBB~BtBRPdA`AFFhA`A~DnD~CnCz@v@pAhAXXnC`CNNNJVTdCzBlIjHZVv@p@bA|@jDzCxCfCnEvDnA`A~@t@p@h@XVDDx@r@`DjCZVj@b@BBjCxBpAfARPDDhA|@dAv@PNb@`@p@f@fBxAjBxAhA|@NLfFbEfBxAhA~@jCvBfA|@|ArAhBzAfCtBb@^nGrF|@n@~IlHrAfAZVlCtBhBxA~@t@ZVZVZVtEtD~E~DZVnC|BTNFF`DfCZVrB`BbCpBfBxARNhEhDjAbAxAjAlB|ArC`Cp@j@zDjDdBxAFFv@p@ZVZVZXZVZVt@n@ZXjA`ADFZVv@r@XVlAjAZZb@`@fAdAv@t@ZXXXBBTT\\Z\\\\z@x@JHx@t@NNLLLLJHLLJLLJp@p@t@t@TRl@j@t@r@z@x@~@~@bA~@ZXVTPPz@|@p@n@FDFF^\\RRBBDBBBBBvAtApAhAZXLLbA`Ah@d@JJnBrBh@l@j@n@lAtAZ\\p@p@HHxArAj@f@l@j@RPDFpAjAPNdAdAxArARRfC|BRRv@r@fC`CfB`B`@Z\\XfBxAZVDDTRDBBBxClC`@\\RPFDp@j@~@v@|DbDXT^X|CfCbAv@xBdB^XNL~GfFVPDDtB|ANLPL\\V~AjAt@f@`@\\r@h@DB~@p@lBtAFDrBzAdDbCdBnA\\Vj@b@~AhAPLlCdBPL`@VnBlAb@V\\TRLf@Xh@\\RJzA|@r@`@lCvAdAh@tBfA\\RvC|A`Ah@^R~@d@\\RVLzAx@d@VpKzFzGjD\\RhHxDtDnBDBFBPHbBz@|@d@XL|BjAD@DBl@Zj@XlCtAhBx@l@VdAb@vAj@xAf@hGtBjAd@xAh@d@P^TtAj@fDpApAf@XLzAx@j@\\x@j@`Ax@bCnBJHr@r@RRFD|BtB~BtBPPjBdBb@`@|AxAZXhAdALLRNZVnB~Ar@j@?JBHDJXZXXBBTTDDb@`@JJPRFDVXZ\\JLFFDHLRBD@BLRLLNZFLBDDLLb@L`@Jd@Nt@?B@NDd@BTH~@@vCCNCL_@hCCJId@SfAEVGXI`@Kh@c@fBWfA]rAS|@Kb@}@xDK^Kb@Op@SfCAvAFbBH~@L|@Dr@Nt@Rp@`AlC^t@|@fB~AfC|DnHtD~GLRbB`D@BPZnBjDlBrDR^h@dAx@`BNVP\\l@bA`AhBR^b@x@BDhCzEHNfAlBd@z@vAlCHNj@bAh@~@FJR^z@~AR`@P\\\\l@^n@LTDFHNr@nAR`@Xj@x@zAv@xADHLTr@pAFLRZBFfAnB`AhB^r@HNtAbCnAxB`@x@b@~@BFXr@Tn@L\\Tn@bAlDZvBz@vEp@~DRfARjARhAJn@p@nDF\\bAjGHb@Hd@Hd@d@rCHf@h@pCThArCzO`@lCf@dCj@tCPl@Jb@DPl@bBfBlEdC~FRh@vEtKlAzC|@vBP`@BFb@|@^x@Vl@`A|Bz@pBf@jAh@pAJTJV`DvH^|@pAzCRd@vAfDLZBDHRn@vAFLZt@rA`DRd@DNLVBHDHlBrEdAdCDFLX~@pBpAxBJPJP`@l@xH`MjApBvLlR~AtClGvJ`DbF`A|A`EvGnAnB|BtD~FpJj@|@jDvFT\\R^`AzAZf@Xd@LRj@|@dAdBDFNTT^~@zAXd@NV`@r@vAxBj@|@HLJN~AhCJN~@|AHLLPXd@z@tAb@r@b@p@LTFHLR|@zAr@jAFJHLFJz@tAv@pA`@n@jAjBZf@NTJPFL`AzAHNPXjAjBT^BBPXT^vAvBrAvBzBnDDJxAxBx@nADDrAbBFF~@~@l@l@VRXVDBVRZVNJvA~@tAv@lAh@h@TLDPFx@XlA\\bAXb@H`AVJBv@RbAXJBh@LzCt@^JjEfAlEfA`@JLB|FxAdDx@D@`@J~@Vn@N|Cv@h@LVHD@`@JvA\\lCp@dDx@vBh@bCn@\\HB@fAXbBb@t@RlBf@bAVHBVF~DbApAZB@\\HdBb@\\HXHrA\\`@J`@JRF`ATp@PRFLBjEjAPDNDhCn@hAVEGCEECCCaA]kBi@a@MQGOC{Bo@m@OgCo@cAWyCu@`@_BLg@\\sAr@iCJc@dAaE`AcDZoA\\cBFaAC_BGoCAo@E}BCmACiAAY?c@AaACg@AOCk@Cg@MaCIsBGgAImE?wDKkBEu@KYCK"}
/// travelAdvisory : {"tollInfo":{"estimatedPrice":[{"currencyCode":"INR","units":"200"}]},"speedReadingIntervals":[{"startPolylinePointIndex":0,"endPolylinePointIndex":106,"speed":"NORMAL"},{"startPolylinePointIndex":106,"endPolylinePointIndex":111,"speed":"SLOW"},{"startPolylinePointIndex":111,"endPolylinePointIndex":249,"speed":"NORMAL"},{"startPolylinePointIndex":249,"endPolylinePointIndex":251,"speed":"SLOW"},{"startPolylinePointIndex":251,"endPolylinePointIndex":527,"speed":"NORMAL"},{"startPolylinePointIndex":527,"endPolylinePointIndex":531,"speed":"SLOW"},{"startPolylinePointIndex":531,"endPolylinePointIndex":592,"speed":"NORMAL"},{"startPolylinePointIndex":592,"endPolylinePointIndex":595,"speed":"SLOW"},{"startPolylinePointIndex":595,"endPolylinePointIndex":923,"speed":"NORMAL"},{"startPolylinePointIndex":923,"endPolylinePointIndex":934,"speed":"SLOW"},{"startPolylinePointIndex":934,"endPolylinePointIndex":2986,"speed":"NORMAL"}]}

class Routes {
  Routes({this.legs, this.distanceMeters, this.duration, this.polyline, this.travelAdvisory});

  Routes.fromJson(dynamic json) {
    if (json['legs'] != null) {
      legs = [];
      json['legs'].forEach((v) {
        legs?.add(Legs.fromJson(v));
      });
    }
    distanceMeters = json['distanceMeters'];
    duration = json['duration'];
    polyline = json['polyline'] != null ? RoutePolyline.fromJson(json['polyline']) : null;
    travelAdvisory = (json['travelAdvisory'] != null && json['travelAdvisory'] is Map) ? TravelAdvisory.fromJson(json['travelAdvisory']) : null;
  }

  List<Legs>? legs;
  int? distanceMeters;
  String? duration;
  RoutePolyline? polyline;
  TravelAdvisory? travelAdvisory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (legs != null) {
      map['legs'] = legs?.map((v) => v.toJson()).toList();
    }
    map['distanceMeters'] = distanceMeters;
    map['duration'] = duration;
    if (polyline != null) {
      map['polyline'] = polyline?.toJson();
    }
    if (travelAdvisory != null) {
      map['travelAdvisory'] = travelAdvisory?.toJson();
    }
    return map;
  }
}

/// tollInfo : {"estimatedPrice":[{"currencyCode":"INR","units":"200"}]}
/// speedReadingIntervals : [{"startPolylinePointIndex":0,"endPolylinePointIndex":106,"speed":"NORMAL"},{"startPolylinePointIndex":106,"endPolylinePointIndex":111,"speed":"SLOW"},{"startPolylinePointIndex":111,"endPolylinePointIndex":249,"speed":"NORMAL"},{"startPolylinePointIndex":249,"endPolylinePointIndex":251,"speed":"SLOW"},{"startPolylinePointIndex":251,"endPolylinePointIndex":527,"speed":"NORMAL"},{"startPolylinePointIndex":527,"endPolylinePointIndex":531,"speed":"SLOW"},{"startPolylinePointIndex":531,"endPolylinePointIndex":592,"speed":"NORMAL"},{"startPolylinePointIndex":592,"endPolylinePointIndex":595,"speed":"SLOW"},{"startPolylinePointIndex":595,"endPolylinePointIndex":923,"speed":"NORMAL"},{"startPolylinePointIndex":923,"endPolylinePointIndex":934,"speed":"SLOW"},{"startPolylinePointIndex":934,"endPolylinePointIndex":2986,"speed":"NORMAL"}]

class TravelAdvisory {
  TravelAdvisory({this.tollInfo, this.speedReadingIntervals});

  TravelAdvisory.fromJson(dynamic json) {
    if (json['tollInfo'] is Map && json['tollInfo'].containsKey('estimatedPrice') && json['tollInfo']['estimatedPrice'] is List) {
      tollInfo = json['tollInfo'] != null ? TollInfo.fromJson(json['tollInfo']) : null;
    }
    if (json['speedReadingIntervals'] != null) {
      speedReadingIntervals = [];
      json['speedReadingIntervals'].forEach((v) {
        speedReadingIntervals?.add(SpeedReadingIntervals.fromJson(v));
      });
    }
  }

  TollInfo? tollInfo;
  List<SpeedReadingIntervals>? speedReadingIntervals;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (tollInfo != null) {
      map['tollInfo'] = tollInfo?.toJson();
    }
    if (speedReadingIntervals != null) {
      map['speedReadingIntervals'] = speedReadingIntervals?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// startPolylinePointIndex : 0
/// endPolylinePointIndex : 106
/// speed : "NORMAL"

class SpeedReadingIntervals {
  SpeedReadingIntervals({this.startPolylinePointIndex, this.endPolylinePointIndex, this.speed});

  SpeedReadingIntervals.fromJson(dynamic json) {
    startPolylinePointIndex = json['startPolylinePointIndex'];
    endPolylinePointIndex = json['endPolylinePointIndex'];
    speed = json['speed'];
  }

  int? startPolylinePointIndex;
  int? endPolylinePointIndex;
  String? speed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['startPolylinePointIndex'] = startPolylinePointIndex;
    map['endPolylinePointIndex'] = endPolylinePointIndex;
    map['speed'] = speed;
    return map;
  }
}

/// estimatedPrice : [{"currencyCode":"INR","units":"200"}]

class TollInfo {
  TollInfo({this.estimatedPrice});

  TollInfo.fromJson(dynamic json) {
    if (json['estimatedPrice'] != null) {
      estimatedPrice = [];
      json['estimatedPrice'].forEach((v) {
        estimatedPrice?.add(EstimatedPrice.fromJson(v));
      });
    }
  }

  List<EstimatedPrice>? estimatedPrice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (estimatedPrice != null) {
      map['estimatedPrice'] = estimatedPrice?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// currencyCode : "INR"
/// units : "200"

class EstimatedPrice {
  EstimatedPrice({this.currencyCode, this.units});

  EstimatedPrice.fromJson(dynamic json) {
    currencyCode = json['currencyCode'];
    units = json['units'];
  }

  String? currencyCode;
  String? units;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currencyCode'] = currencyCode;
    map['units'] = units;
    return map;
  }
}

/// encodedPolyline : "sh}fCeewnLGy@`@?dADf@@\\BD?|ADr@BV?P?b@?rBQ`AGx@ElAIO_AWiDY_EWyDK}AI{@KgBIoAW}DOyA?_@RMd@a@t@g@h@_@NGDCJAHGXUJGf@YLKfAu@bBkAPMPK`Ao@xAaAtBuAt@g@`Ao@rAy@`Ao@t@g@j@_@`BiA`CaBpBqAz@w@HINIdBqAvAcAfCeB|@g@fBoA`As@jA}@NIrCsBvA}@LGzA]|AQxAMRCr@G~@Gj@C|@GTEZELCREfAWXGxASd@GfCKrBBdBHP@F?bBNP@P@b@Bj@BXB`@BlBBF?nB?rC@~@BD?|@AnAMjAQ`AQrASvB[nAQj@IZIdBe@dAc@LE|@_@bBs@d@ShAe@`Bw@r@[bAa@zD_BrB}@j@O`A]ZGhBc@`@KhAY|@UhAYHCl@OnBg@n@Or@QrAa@TI`EiBpFaC^QZMbAe@^O~BeA`EiBzAq@fBs@`CaAn@c@zB_A^Q`DuAl@SzDuA`C}@`A]b@Q\\M|@]pAi@x@YLCl@Ud@O^OrDsAxFsBfAc@nC}@dAc@`@MREz@OF?`@Er@I|@I^?XAfAIREXKXIFClP{G|CuApI_Fl@[XQhAw@`HsDxAo@~K}D~@YpIyCbDqA`DgAfC}@jC_AVKTKTKJEJEzAq@zAq@hCgAdDsAHEHEFAdCiAx@]~@a@fDuAzAq@`Aa@DAXM^Qx@a@rB{@h@a@~A}AdAaAd@a@NWNa@Ns@`@oBX{ALs@Bi@A{C@eCEsECuA?aC?}@?{ACcEAw@C{BAy@EwEIeEAqAA_ACwECwE?EUyPC_C?gACI?EAG?G?O?EA[AMCWCWCSCSAUV@l@D~AD|AFjADpADtAFtBFrAFr@@~@B^@r@D~ABjADxBFlBDdDJT?rAFT@f@@pBD`BFd@Dh@DZ@h@BjAB~AHX@pDRD?f@Dn@Jx@TZLXLv@^n@Vd@VNH^TPHB@LFVJVHTFXFNBPBh@H`@F`Gn@l@Fx@L~AVPBb@FzC`@rC^\\DD@|@JlBXhAPVDRBpB\\`Dh@pAP|Cb@l@J~A`@|A\\pAXrBb@fB^XFr@PlCh@~A\\xBf@|AZlFdAbB^dCj@j@JdATbARNBdEx@dE~@tAZdDn@fARdATn@JXFf@JRDLBn@Ln@LNDLBbARb@HXDZF~AZlBZnBXdDh@l@JtBTb@DXBTBp@FrBN|AJvBNnCLzCRrALv@FxBRzAPb@D`@DRB~ARn@HdCXv@Hb@FhAL\\D|ARVBxANz@JdAHjALX@p@D^Bj@D`@@zBNtBL\\@j@B`@B`@@^DjAJb@D`@FL@l@Jh@JB?j@Lz@Pr@NVFZFTDJD|@VfAb@bBr@ZNx@Zf@T`@P\\N`@PRHJD`@P^N^PB@jAh@bAf@bAh@tAt@|Az@dAj@lAp@fAj@h@Zx@b@VL~Az@hAn@l@ZtAv@FBVNx@d@f@ZVPRNh@^b@\\lA`Aj@b@PLHH~@r@FDx@l@`@Z`@ZxAjAp@f@fBrAj@`@l@`@VNf@Vp@Zl@Rl@Tx@Rr@R\\HdAX|@RhB^jB\\NBLBNBvAXjBVr@JrARL@bAJn@Fz@@\\?Z?r@ArAEbAGvEUfBInBKpCIjAAt@?pCAV?fB?lB?Z?lCA|@AJ?bC?x@A`@Az@Cp@G`AKnC]fAMtAOn@Cl@GTCV?tBJdAHd@B`@DjAFxBJ|BP~BNpCRpBNd@@xBNfBL`CNr@D`@@d@?f@DPAT?Z?r@BfFD`A?nJJnC?pA?j@AnAIx@M~@OlBi@zCmAtBw@vJuDnBi@hCcAdDsAnDmAhDk@v@Gj@GbB?z@EPA`BKhAGb@ClAEv@E\\AdCMxAGnCOdBKfAI^AnAMjCMdBKhCMfESvCQpAIpBKnAG~@G`DQ`H_@hGc@t@EH?HAlCKtDUVCH?FAl@CnBKtLs@|BI~BMdDQfBI|Hc@t@ERAfCMrBKpAKH?H?fBIhBGtEWr@EvEWh@O\\CZA~AKpAG|@Gh@CpAId@CjAGjBKj@ClAI\\C~@Gp@C~@Gn@El@CdAGz@EbAGhAG~@G|@GdAGr@Ef@ETA|@Gt@Gf@BJ?^FXCHAh@Cj@C^CfAEr@EbCM^CzFYlCOn@CpBOtIc@xCQnFYzF[xEWpDQJAfAGxDSbBIbCOnBKx@Gl@Ej@AvAIhBKdBK|@GnAI|AGlBKxAIz@E~AIlAKh@GPExAQtAYr@QxCo@lAY^Gz@UD?vA[`@InCk@dDs@bASFAfE_AnDu@TEpBc@`B]dASjB_@LCnAYJCr@MhE}@`AUNCfD{@NCxA[bDq@xFoAXGv@Od@GJCrAWj@M|EeAfDu@@GHI`@IrBa@^IREHANCx@SvAYdAUjDw@h@MlCm@TEVGZGPEnEaA~A]v@QNChB_@fAUbAULE~A]f@M~Dw@fAUdAS~@Up@QdAUt@OPClAUxBg@vA[z@SbDs@TFZId@KdB]jB_@nBa@nCk@r@QdAUdBa@b@IdCk@^Id@K|@Md@EpAKF?p@?P@H?@CBABAB?BAB@B?@@BBJ@^DV@pBHf@FB?^F~@R`AT`AZb@Nh@Tt@^BBVP\\TDDj@`@TTXTp@p@d@f@v@v@XXvB|BPRlAnAr@t@BDRTjAjATTrBvBvA~AdBjBLLl@l@nArAhAlAFFf@f@dDpDn@n@pCzC^^hAnAn@t@FDLLl@l@pAtAv@t@l@f@j@\\HDd@Xj@`@pAx@zA~@fAt@v@j@rA|@pBrAfBnAbBfAxCpBvCnBjBnAz@x@`@VfAv@~@l@HDFDHDFDFDJEDADAH@TFr@X~@VdARL@r@Fh@DlAXPDxBj@Ef@CTEj@AHI`BCZEl@MhBCVC\\AR?RAV@`@@d@Bd@D|@DhAHbB@JF`BB\\@Z@NBb@DbAFzADjADdA?H@L?L@N?Z@j@@h@?j@@N?L?H@\\?R@J?D@P@F@HH~@PdBD`@ThBHn@XfCd@jE\\zCRdBF`@D\\PzAVtBBRHd@LdA@DVtBDZDh@@N@DB`@B`@D~@FfB?FF`BBx@Bx@@~A@H?Z?j@DvIB~C?j@?t@@f@?x@BjBBhA@N@ZBzABh@DbA?JBj@@JDdAJfC@TFxA?HBr@@T@XB`ABj@?L@D@\\?V?P?TARCf@ALC\\IfAALALAFC`@?DEXAJO~@APALANAv@AVCf@Gt@Gx@Gh@AHCVId@Kr@o@lDKd@i@zCI\\ENGRGPGLMXuApCcBdD_@t@a@x@eArB[n@OXMPKNMRa@h@[`@_@EkBF[?q@Ek@KqAWqBe@QEOEq@O_@E[CO@O@a@HYDM@_@?m@?eACqACG?[C[E[CKCD}EmBAqC?aAH@hE|@CrBET?T@VDXD\\DJ@JBZBZDZBF?pABdABl@?^?LAXE`@INANAZB^Dp@NNDPDpBd@pAVj@Jp@DV?nBG^DZa@`@i@LSJOLQNYZo@dAsB`@y@^u@bBeDtAqCLYFMFQFSDOH]h@{CJe@l@f@XVxEpDf@^nDpCzAjAh@^ZP~BhBdAt@VJf@N~ANb@F|ANNBJDB@HBDBHDVX\\b@BBHHhArAX\\HJPXN\\FVFLFLHJLLNNb@VLHZRHDPJ\\VRTFJHPJPZx@Zn@bAdCf@fAf@fAVj@Vx@Lr@Hv@B^T|D@Dd@dGN~CBdABnA@NA|BAzA?fF?DC`EAh@?X?vCB`AJ`AH~@RbBT~BPhBZ`DP`BDb@b@xE@B?LJ~BFlELbFBl@NdETbCx@zBHTb@pAHf@?`@?f@In@I~Ay@fHCTc@~DOnB?L@tADbA@JAr@OfAMt@ERMz@CNg@xCEt@@r@RWDE`@g@VGn@Eh@EB?l@GbAGt@Gz@CJA^AF?d@Ef@GjAOF?JCRCd@IBAVjAJ`@NRLEDA^QTOBCv@m@tAy@FE\\Qh@YNI^Q^OFCf@QVOHANEZET?~AA|CGT@vC@rCBJ@fD?D?vADV?Z@v@?pA@^B|BNz@Hl@DR@hBLD?nBNzCXpAN`CVPBpABh@CXCPAvBA`AJ^BpCZL@TDlDj@NBzEz@nC`@D@hAVf@TxAbApA~@v@|@d@j@dA|@j@d@h@h@r@f@JFtAd@|@VF@nAVh@Pt@N~@RNBPDdBZlBf@\\JRFN@dA@b@?F?xDBn@?lB?jA?bA@lA@hB@bB@f@EdBY`AO`Du@bB]BA|AYv@QpBaA~Aw@JGvAm@r@[\\Q^QvCqAfCkAtDgBhAg@zCuAZMBAZMjCsAtAo@vAm@f@Ut@[bBu@h@YhAk@l@Yn@_@v@m@t@s@fA_Ap@o@h@e@X]TYZc@`@k@FKP[b@u@Xm@Vk@j@oAb@}@DKFK`@{@jAeCP[Zk@RWn@q@f@m@f@m@|A_Bp@u@DGFGpAyAt@{@tAaBhAuAb@i@j@s@r@y@^g@JQFI@ELYLSVILD\\Nn@TtBx@PFrAh@`Ab@HHl@f@~@fAFHb@p@v@dAFFx@t@dA|@tAx@n@d@x@`ADBVPPH^TTLZPx@f@DBvAx@dDlBvAv@fEbC`CtAjAp@xDzBpAt@xA|@x@d@ZRDB|@h@h@Xj@\\tC`BTN`@Rv@b@t@b@b@Xb@Tj@Xn@Z^N^PRHRHZJJDLBXD`@FNB\\DXDb@HXFj@J~Ab@`AXt@R|Bl@r@Tj@PZHfA\\zBp@VFHBHB^JvBl@j@Nv@TVHTFzA`@|@XXJf@N`@NPFLDLHPHHFHDJF~@\\hD~@LDtBl@xCt@|EtALDJBRFtCx@rCr@bBb@~@V\\Jf@LdAVf@N\\JRFj@R^L`@NDBXJ\\PVP`@V\\Z\\ZZ^NPNRTZt@nAr@jAbAdBXh@pBhDT^x@rAlAtBJP\\j@`@p@d@x@hBzCtAbCbBlC~BzDbBrCnBfDxAfCZf@^r@j@v@NVb@d@PRf@b@XR\\Tx@`@t@Xv@Tv@Lp@Hn@@F?F@jABpCBbEFh@@\\@R?zAD|ADbEH\\@zABR?R?NAR?N?N@N?R@R@P?R@P?\\?^@X@`@@^@Z@\\?n@Bp@@`@@P@N?X@f@@\\?P?R?J?H@D@H@F@H?Z@ZB\\JPFPFRBVBxBBl@@`ABrA?l@CXC\\AL?F?T@VBbAJt@N~@VZH\\Jn@Vr@ZnAp@PJRL|D|Bv@b@rD~BjBlA`Ar@hI|Fb@ZdHdF`An@FDTP|AdAbI`GLJh@b@x@l@pAbAtAdAnEbDPJVTLJNJxAjAfA~@jAx@`@ZTRx@j@dAr@p@`@TLZRtBrAvBrAjEnCrBlA`BdAr@b@v@h@TPVTX\\NZtAvAfCdC|@z@LLn@l@bGdG~D|DhAjAbB~AHHHHfAhA`B|Aj@h@bCbCbA~@b@b@`AbAlAlAzAvAnBhBXZPTJJLJb@b@r@r@VR^X^Z`@VvAx@vAv@`Ah@v@^jB`AlCvAfAh@XNXT^Tn@\\p@b@^V~AjAJHBBbB|AVVhAjAr@z@\\\\`AfAVZj@l@n@t@h@l@t@z@z@bAX`@Z`@hApA`CxCt@x@\\b@VZVZBBZ`@d@l@`@h@V`@f@z@LZR\\DJLXJVXn@`@hAd@lA|@dC`@fAXhA@F?BAXAJ@Bf@|AN`@l@~A^dA^bAv@zBd@pANRVp@FRJVHRDHPZd@p@DDDF^Xb@Z`Ad@l@RNDD?RDNBJ@P@H?`@?b@A\\Eh@G|@IvASn@Ir@Gh@Ap@Cx@@X@JBN@ZLVJf@Tf@Vl@b@b@`@~AzA`AbA|AbB`AbADFlArAzBhCnAxAXZ`@d@b@f@p@v@f@j@z@bAxA~Ax@z@lApAr@t@zA~AHJ~DjEhAlAlDvDRTX\\HHxAdB~@hA`AhATVhAtAVXjArAbBlBdAhAvB`CRTXZXXXZh@j@tAzAfCpCxDhEHJh@l@b@f@b@f@`@b@d@p@f@t@Zj@JPXj@Xn@P\\JTDLl@`BZdAZpAF\\Jj@F\\Jl@\\lCHl@?BZ|BJv@Lx@RlALx@BT@LBLBRBPNhAFd@LjA@FF\\XnBNjADRBNLz@Ff@BTDl@Dh@@T@ZBtAA~BA~@AL?V?LAd@CbAIzFAhB?V?DAF?\\AfA?pACxA?t@?H@^?b@Bd@BXD^L`APx@Pp@\\fA\\t@^p@X`@HJX^v@z@TTBBlErElFnFXXDDRRXZJHLNvBtBfAhAx@|@DDFDLNBBVVBBHHfDhDf@h@XZ`DbD`FfFrBtBpCvCpBrBXXjAlAzE|EzBzB`B`BdC`CfBfB|A~AfAfAjAlARV`@b@^b@j@t@t@hABBp@fAd@|@l@pAj@~ATn@L`@HVDPBFFj@Jh@RRPP\\^VTRPb@XNHVLh@VtB~@ZPrB`AbAd@|BfALFdCjA|Av@|Av@rCpApAj@b@RdC`ApAj@zAf@^PjAh@`A^j@Tt@X^NxCfA~B`ATJVJzAp@XNt@Zf@XXPBBNHJFB@BBr@b@HDRLB@FDVPl@b@~@p@VPLJf@`@l@f@t@l@p@n@vChCfAz@FF`@\\JHRPJJ|@t@LHLHVR^Xj@`@TPXPTNJFxBtAXPhAr@l@^z@d@ZN`@PVHJD\\H\\HNBNDZDf@FV@R@V@\\?j@AXARAVCXEVEJAJCNEJCb@MDAFAJE`@ORK^Qp@c@VSd@[j@g@VSNKtAkAhA_AbDkCHGBA|@s@lB_BrBeBxBkBlB}Ah@a@~@y@nAcA`@]LKLIJKDCLMLIt@o@^Yn@c@XOd@Wj@UTKx@[jA]LCn@M|@Or@Gb@ED?b@Cd@AZ?X?j@@V?bAHtARVBHB`@Hh@JnA\\d@R~@`@j@XrA`Ab@^jBdBFFPPt@v@^`@f@h@^^d@h@dBhBHNdAfAjAnAzB~Bn@p@t@v@t@x@f@h@NNTTf@j@d@f@j@n@Z\\x@z@dAdAjAnA~A~An@j@z@v@p@l@RNPP`A|@v@p@r@p@x@t@ZVlEzDxArAvAnA~@x@FFFFZVlAdAb@b@|@t@j@f@f@`@xBlBBB~BtBRPdA`AFFhA`A~DnD~CnCz@v@pAhAXXnC`CNNNJVTdCzBlIjHZVv@p@bA|@jDzCxCfCnEvDnA`A~@t@p@h@XVDDx@r@`DjCZVj@b@BBjCxBpAfARPDDhA|@dAv@PNb@`@p@f@fBxAjBxAhA|@NLfFbEfBxAhA~@jCvBfA|@|ArAhBzAfCtBb@^nGrF|@n@~IlHrAfAZVlCtBhBxA~@t@ZVZVZVtEtD~E~DZVnC|BTNFF`DfCZVrB`BbCpBfBxARNhEhDjAbAxAjAlB|ArC`Cp@j@zDjDdBxAFFv@p@ZVZVZXZVZVt@n@ZXjA`ADFZVv@r@XVlAjAZZb@`@fAdAv@t@ZXXXBBTT\\Z\\\\z@x@JHx@t@NNLLLLJHLLJLLJp@p@t@t@TRl@j@t@r@z@x@~@~@bA~@ZXVTPPz@|@p@n@FDFF^\\RRBBDBBBBBvAtApAhAZXLLbA`Ah@d@JJnBrBh@l@j@n@lAtAZ\\p@p@HHxArAj@f@l@j@RPDFpAjAPNdAdAxArARRfC|BRRv@r@fC`CfB`B`@Z\\XfBxAZVDDTRDBBBxClC`@\\RPFDp@j@~@v@|DbDXT^X|CfCbAv@xBdB^XNL~GfFVPDDtB|ANLPL\\V~AjAt@f@`@\\r@h@DB~@p@lBtAFDrBzAdDbCdBnA\\Vj@b@~AhAPLlCdBPL`@VnBlAb@V\\TRLf@Xh@\\RJzA|@r@`@lCvAdAh@tBfA\\RvC|A`Ah@^R~@d@\\RVLzAx@d@VpKzFzGjD\\RhHxDtDnBDBFBPHbBz@|@d@XL|BjAD@DBl@Zj@XlCtAhBx@l@VdAb@vAj@xAf@hGtBjAd@xAh@d@P^TtAj@fDpApAf@XLzAx@j@\\x@j@`Ax@bCnBJHr@r@RRFD|BtB~BtBPPjBdBb@`@|AxAZXhAdALLRNZVnB~Ar@j@?JBHDJXZXXBBTTDDb@`@JJPRFDVXZ\\JLFFDHLRBD@BLRLLNZFLBDDLLb@L`@Jd@Nt@?B@NDd@BTH~@@vCCNCL_@hCCJId@SfAEVGXI`@Kh@c@fBWfA]rAS|@Kb@}@xDK^Kb@Op@SfCAvAFbBH~@L|@Dr@Nt@Rp@`AlC^t@|@fB~AfC|DnHtD~GLRbB`D@BPZnBjDlBrDR^h@dAx@`BNVP\\l@bA`AhBR^b@x@BDhCzEHNfAlBd@z@vAlCHNj@bAh@~@FJR^z@~AR`@P\\\\l@^n@LTDFHNr@nAR`@Xj@x@zAv@xADHLTr@pAFLRZBFfAnB`AhB^r@HNtAbCnAxB`@x@b@~@BFXr@Tn@L\\Tn@bAlDZvBz@vEp@~DRfARjARhAJn@p@nDF\\bAjGHb@Hd@Hd@d@rCHf@h@pCThArCzO`@lCf@dCj@tCPl@Jb@DPl@bBfBlEdC~FRh@vEtKlAzC|@vBP`@BFb@|@^x@Vl@`A|Bz@pBf@jAh@pAJTJV`DvH^|@pAzCRd@vAfDLZBDHRn@vAFLZt@rA`DRd@DNLVBHDHlBrEdAdCDFLX~@pBpAxBJPJP`@l@xH`MjApBvLlR~AtClGvJ`DbF`A|A`EvGnAnB|BtD~FpJj@|@jDvFT\\R^`AzAZf@Xd@LRj@|@dAdBDFNTT^~@zAXd@NV`@r@vAxBj@|@HLJN~AhCJN~@|AHLLPXd@z@tAb@r@b@p@LTFHLR|@zAr@jAFJHLFJz@tAv@pA`@n@jAjBZf@NTJPFL`AzAHNPXjAjBT^BBPXT^vAvBrAvBzBnDDJxAxBx@nADDrAbBFF~@~@l@l@VRXVDBVRZVNJvA~@tAv@lAh@h@TLDPFx@XlA\\bAXb@H`AVJBv@RbAXJBh@LzCt@^JjEfAlEfA`@JLB|FxAdDx@D@`@J~@Vn@N|Cv@h@LVHD@`@JvA\\lCp@dDx@vBh@bCn@\\HB@fAXbBb@t@RlBf@bAVHBVF~DbApAZB@\\HdBb@\\HXHrA\\`@J`@JRF`ATp@PRFLBjEjAPDNDhCn@hAVEGCEECCCaA]kBi@a@MQGOC{Bo@m@OgCo@cAWyCu@`@_BLg@\\sAr@iCJc@dAaE`AcDZoA\\cBFaAC_BGoCAo@E}BCmACiAAY?c@AaACg@AOCk@Cg@MaCIsBGgAImE?wDKkBEu@KYCK"

class RoutePolyline {
  RoutePolyline({this.encodedPolyline});

  RoutePolyline.fromJson(dynamic json) {
    encodedPolyline = json['encodedPolyline'];
  }

  String? encodedPolyline;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['encodedPolyline'] = encodedPolyline;
    return map;
  }
}

/// steps : [{"navigationInstruction":{"maneuver":"DEPART","instructions":"Head east toward Serenity Garden Rd"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right onto Serenity Garden Rd\nPass by Serenity Garden (on the left)"}},{"navigationInstruction":{"maneuver":"TURN_LEFT","instructions":"Turn left at Shree Ravi Randal Temple onto Kalavad Rd/Rajkot Rd\nPass by LAUGH A LATTE (on the left)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right at Bombay auto onto 2nd Ring Rd\nPass by Solanki Eggs Santor (on the right)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right onto NH 27\nToll road\nPass by KHODIYAR AUTO (on the left in 3.1 km)"}},{"navigationInstruction":{"maneuver":"TURN_SLIGHT_LEFT","instructions":"Slight left\nPass by Shree Mahavir Courier Services Pvt Ltd (on the left in 900m)"}},{"navigationInstruction":{"maneuver":"MERGE","instructions":"Merge onto NH 27\nPass by Shivalaya no 2 (on the right in 1.6 km)"}},{"navigationInstruction":{"maneuver":"TURN_SLIGHT_LEFT","instructions":"Slight left toward Service Rd"}},{"navigationInstruction":{"maneuver":"NAME_CHANGE","instructions":"Continue onto Service Rd\nPass by Hyundai Gondal (Shiv) (on the left)"}},{"navigationInstruction":{"maneuver":"TURN_SLIGHT_RIGHT","instructions":"Slight right toward NH 27"}},{"navigationInstruction":{"maneuver":"MERGE","instructions":"Merge onto NH 27\nPass by Shree Tejashvi Hanuman & Shree Shanidev Temple (on the left in 750m)"}},{"navigationInstruction":{"maneuver":"TURN_LEFT","instructions":"Turn left at Trishul tyre\nPass by ASHIRWAD AUTO PARTS (on the right)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right at Gundala Chowkdi onto Gondal - Jamkandorana Rd/Gundala Rd\nContinue to follow Gondal - Jamkandorana Rd\nPass by Ambaji Mandir & Murti Bhandar (on the right)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right\nPass by શિર્વારા વેબ્રીજ (on the left)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right at NOVELT POLYMERS®"}},{"navigationInstruction":{"maneuver":"TURN_LEFT","instructions":"Turn left\nPass by Flowmark Polyplast PVT.LTD. (on the right)"}},{"navigationInstruction":{"maneuver":"TURN_LEFT","instructions":"Turn left"}},{"navigationInstruction":{"maneuver":"TURN_LEFT","instructions":"Turn left\nPass by શિર્વારા વેબ્રીજ (on the right in 700m)"}},{"navigationInstruction":{"maneuver":"TURN_LEFT","instructions":"Turn left onto Gondal - Jamkandorana Rd\nPass by the gas station (on the right)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right\nPass by સોનાપુરી (સ્મસાન) ગુંદાળા (on the right)"}},{"navigationInstruction":{"maneuver":"TURN_LEFT","instructions":"Turn left at S T. Dhol Highschool Library onto Patidad Rd\nPass by Bajrang Enterprise (on the left)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right to stay on Patidad Rd\nPass by Kanaiya tea stall & ice cream (on the right in 3.1 km)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right at GOMTA FATAK onto NH 27\nToll road\nPass by Gomta chowkadi (on the left)"}},{"navigationInstruction":{"maneuver":"TURN_SLIGHT_LEFT","instructions":"Slight left at Khodal gathiya onto NH151\nPass by G N D Electronics (on the right in 850m)"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right at Mangal Bishi onto Junagadh Byp\nPass by Raysingh Rawat (on the left in 5 km)"}},{"navigationInstruction":{"maneuver":"TURN_SHARP_LEFT","instructions":"Sharp left"}},{"navigationInstruction":{"maneuver":"TURN_RIGHT","instructions":"Turn right\nPass by Jagani Temple (on the left in 500m)"}},{"navigationInstruction":{"maneuver":"NAME_CHANGE","instructions":"Continue onto Zanzarda Rd\nPass by Indian pan and provision store (on the left in 450m)\nDestination will be on the left"}}]

class Legs {
  Legs({this.steps});

  Legs.fromJson(dynamic json) {
    if (json['steps'] != null) {
      steps = [];
      json['steps'].forEach((v) {
        if (v is Map<String, dynamic>) {
          steps?.add(Steps.fromJson(v));
        }
      });
    }
  }

  List<Steps>? steps;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (steps != null) {
      map['steps'] = steps?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// navigationInstruction : {"maneuver":"DEPART","instructions":"Head east toward Serenity Garden Rd"}

class Steps {
  Steps({this.navigationInstruction});

  Steps.fromJson(dynamic json) {
    navigationInstruction = json['navigationInstruction'] != null ? NavigationInstruction.fromJson(json['navigationInstruction']) : null;
  }

  NavigationInstruction? navigationInstruction;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (navigationInstruction != null) {
      map['navigationInstruction'] = navigationInstruction?.toJson();
    }
    return map;
  }
}

/// maneuver : "DEPART"
/// instructions : "Head east toward Serenity Garden Rd"

class NavigationInstruction {
  NavigationInstruction({this.maneuver, this.instructions});

  NavigationInstruction.fromJson(dynamic json) {
    maneuver = json['maneuver'];
    instructions = json['instructions'];
  }

  String? maneuver;
  String? instructions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['maneuver'] = maneuver;
    map['instructions'] = instructions;
    return map;
  }
}

class WayPointPojo {
  WayPointPojo(this.latitude, this.longitude);

  double? latitude;

  double? longitude;

  WayPointPojo.fromJson(dynamic json) {
    latitude = json["latitude"];
    longitude = json["longitude"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    return map;
  }
}
