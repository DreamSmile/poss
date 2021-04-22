<%@ Page Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script language="vb" runat="server">

    '�޸�����:����������[û��Ʊ],��ô��ӡ��ͬ��ʱ����ʾ��˰
    '�޸���:��ï��
    '�޸�����:20150701
    '-------------------

    Sub page_load(ByVal S As Object, ByVal E As EventArgs)
    End Sub

    '����д
    Public Function Chinese_Format(X As Decimal) As String
        Dim s As String, sFormat As String, i As Integer, c As String
        Const sString = "�ֽ�Ԫʰ��Ǫ��ʰ��Ǫ��ʰ��Ǫ��"
        Const sNumber = "��Ҽ��������½��ƾ�"
        s = Format(Int(X * 100))
        sFormat = ""
        For i = Len(s) To 1 Step -1
            c = Mid(s, i, 1)
            If c = "0" Then
                Select Case Len(s) - i
                    Case Is <= 1 ' 0��Ԫ֮�� 
                        sFormat = "��" + Mid(sString, Len(s) - i + 1, 1) + sFormat
                    Case 2 ' Ԫ 
                        sFormat = "Ԫ" + sFormat
                    Case 6 ' ��
                        sFormat = "��" + sFormat
                    Case 10 '��
                        if left(sFormat, 1) = "��" then sFormat = right(sFormat, len(sFormat) - 1)
                        sFormat = "��" + sFormat
                    Case Else
                        If Mid(s, i + 1, 1) <> "0" Then sFormat = "��" + sFormat
                End Select
            Else
                sFormat = Mid(sNumber, Val(c) + 1, 1) + Mid(sString, Len(s) - i + 1, 1) + sFormat
            End If
        Next
        Chinese_Format = sFormat
    End Function
</script>
<html>
<head>
    <title>��Ʒ��������</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <script src="./js/jquery-3.2.1.min.js" type="text/javascript"></script>
    <link href="../layerui/css/layui.css" type="text/css" rel="stylesheet">
    <script src="../layerui/layui.all.js" type="text/javascript"></script>

    <style type="text/css">
        #MainTable td {
            word-break: break-all;
            word-wrap: break-word;
            border: 1px solid #000;
        }

        .blk13 {
            margin-top: 22px;
        }
    </style>

    <style>
        <!--
        .mytext_xh {
            color: #222222;
            border: 0;
            solid: #ffffff;
            border-style: solid;
            font-size: 9pt;
            height =20;
            width =60;
            text-align: center;
        }

        .mytext_sphh {
            color: #222222;
            border: 0;
            background-color: #ffffff;
            solid: #ffffff;
            border-style: solid;
            font-size: 9pt;
            height =20;
            width =100;
            text-align: center;
        }

        .mytext_je {
            color: #222222;
            border: 0;
            background-color: #ffffff;
            solid: #ffffff;
            border-style: solid;
            font-size: 9pt;
            height =20;
            width =100;
            text-align: right;
        }

        .mytext_mxrq {
            color: #222222;
            border: 0;
            solid: #ffffff;
            border-style: solid;
            font-size: 9pt;
            height =20;
            width =65;
            text-align: left;
        }

        .mytext_mxbz {
            color: #222222;
            border: 1;
            background-color: #ffffff;
            align: bottom;
            height =20;
            font-size: 9pt;
            text-align: left;
            width: 140px;
        }

        .mytext_dj {
            color: #222222;
            border: 0;
            background-color: #ffffff;
            solid: #ffffff;
            border-style: solid;
            font-size: 9pt;
            height =20;
            width =80;
            text-align: right;
        }

        .hid {
            display: none;
        }

        #divInfo table td {
            padding: 5px;
        }
        -->
    </style>
</head>
<body style="overflow: auto;">
    <script>
        /* �򿪵����� */
        function openBox(djid) {
            var open_j = layer.open({
                type: 2,
                title: false,
                closeBtn: true,
                area: ['50%', '50%'],
                shade: 0.3,
                offset: '100px',
                shadeClose: false,
                id: 'mode',
                moveType: 1,
                btn: ['ȷ��', 'ȡ��'],
                content: '../Tl_cw/zw_xz_eqbuser/zw_xz_eqbuser.html?djid=' + djid +'&djlx='+GetQueryString('djlx'),
                success: function (layero, index) { },
                btn1: function (index, layero) {
                    var dataJ = document.getElementById("layui-layer-iframe" + index).contentWindow
                        .postDataJ();
                    var dataY = document.getElementById("layui-layer-iframe" + index).contentWindow
                        .postDataY();
                    if (dataJ.length == 0) {
                        alert("��ѡ��׷���Ա��");
                        return false;
                    }
                    if (dataY.length == 0) {
                        alert("��ѡ���ҷ���Ա��");
                        return false;
                    }
                    var Jnames = '';
                    var Ynames = '';
                    for (var j = 0; j < dataJ.length; j++) {
                        Jnames += (dataJ[j].name + ',');
                    }
                    for (var y = 0; y < dataY.length; y++) {
                        Ynames += (dataY[y].name + ',');
                    }
                    Jnames = Jnames.substring(0, Jnames.length - 1); //ȥ�����һ��,
                    Ynames = Ynames.substring(0, Ynames.length - 1);
                    window.parent.document.querySelectorAll('#myctrl')[0].contentWindow.changeValJ(Jnames);
                    window.parent.document.querySelectorAll('#myctrl')[0].contentWindow.changeValY(Ynames);
                    window.parent.document.querySelectorAll('#myctrl')[0].contentWindow.setValJ(dataJ);
                    window.parent.document.querySelectorAll('#myctrl')[0].contentWindow.setValY(dataY);
                    window.parent.document.querySelectorAll('#myctrl')[0].contentWindow.getXzSeals();
                    layer.closeAll();
                }
            })
        }
        function GetQueryString(name) {
                var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
                var r = window.parent.location.search.substr(1).match(reg);
                if (r != null) return unescape(r[2]);
                return null;
            }
    </script>

    <div id="divInfo" style="position: fixed; top: 50; left: 400; z-index: 10; width: 260px; height: 400px; overflow: auto; background-color: #FFF; border: #999 1px solid; display: none">
        <table id="fixtab" border="0" cellspacing="0">
            <tbody>
                <tr>
                    <td id="col_0" style="width: 120px; font-size: 12px; display: table-cell;">���</td>
                    <td id="sz_0_0_0" style="display: table-cell;">
                        <input class="rowVal" style="width: 80px; text-align: right;" type="text" value="10"></td>
                    <td style="display: table-cell;">mm</td>
                </tr>
                <tr>
                    <td id="col_1" style="width: 120px; font-size: 12px; display: table-cell;">�µ�����</td>
                    <td id="sz_1_1_0" style="display: table-cell;">
                        <input class="rowVal" style="width: 80px; text-align: right;" type="text" value="25"></td>
                    <td style="display: table-cell;">mm</td>
                </tr>
                <tr>
                    <td id="col_2" style="width: 120px; font-size: 12px; display: table-cell;">�µ�����(��)</td>
                    <td id="sz_2_2_0" style="display: table-cell;">
                        <input class="rowVal" style="width: 80px; text-align: right;" type="text" value="18"></td>
                    <td style="display: table-cell;">mm</td>
                </tr>
                <tr>
                    <td id="col_3" style="width: 120px; font-size: 12px; display: table-cell;">��˰����(Ԫ/��)</td>
                    <td id="sz_3_3_0" style="display: table-cell;">
                        <input class="rowVal" style="width: 80px; text-align: right;" type="text" value="16"></td>
                    <td style="display: table-cell;">mm</td>
                </tr>
                <tr>
                    <td id="col_4" style="width: 120px; font-size: 12px; display: table-cell;">��˰�ϼƽ��(Ԫ)</td>
                    <td id="sz_4_4_0" style="display: table-cell;">
                        <input class="rowVal" style="width: 80px; text-align: right;" type="text" value="20"></td>
                    <td style="display: table-cell;">mm</td>
                </tr>
                <tr>
                    <td id="col_5" style="width: 120px; font-size: 12px; display: table-cell;">�������һ���Ե�λʱ��</td>
                    <td id="sz_5_5_0" style="display: table-cell;">
                        <input class="rowVal" style="width: 80px; text-align: right;" type="text" value="28"></td>
                    <td style="display: table-cell;">mm</td>
                </tr>
                <tr>
                    <td id="col_6" style="width: 120px; font-size: 12px; display: table-cell;">�������ʱ��</td>
                    <td id="sz_6_6_0" style="display: table-cell;">
                        <input class="rowVal" style="width: 80px; text-align: right;" type="text" value="28"></td>
                    <td style="display: table-cell;">mm</td>
                </tr>
                <tr>
                    <td id="col_7" style="width: 120px; font-size: 12px; display: table-cell;">��������</td>
                    <td id="sz_7_7_1" style="display: table-cell;">
                        <input class="rowVal" style="width: 80px; text-align: right;" type="text" value="80"></td>
                    <td style="display: table-cell;">mm</td>
                </tr>
                <tr>
                    <td id="col_8" style="width: 120px; font-size: 12px; display: table-cell;">ˢ���������</td>
                    <td id="sz_8_10_0" style="display: table-cell;">
                        <input class="rowVal" style="width: 80px; text-align: right;" type="text" value="28"></td>
                    <td style="display: table-cell;">mm</td>
                </tr>
                <tr>
                    <td id="col_9" style="width: 120px; font-size: 12px; display: table-cell;">��Ʒ������</td>
                    <td id="sz_9_11_0" style="display: table-cell;">
                        <input class="rowVal" style="width: 80px; text-align: right;" type="text" value="28"></td>
                    <td style="display: table-cell;">mm</td>
                </tr>
                <tr>
                    <td id="col_10" style="width: 120px; font-size: 12px; display: table-cell;">�ر�Լ������</td>
                    <td id="sz_10_12_0" style="display: table-cell;">
                        <input class="rowVal" style="width: 80px; text-align: right;" type="text" value="30"></td>
                    <td style="display: table-cell;">mm</td>
                </tr>
                <tr>
                    <td style="display: table-cell;">
                        <input type="button" style="width: 120px" value="ȷ��" onclick="setWidth()"></td>
                    <td colspan="2" style="display: table-cell;">
                        <input style="width: 110px" onclick="MsgClose()" type="button" value="�ر�"></td>
                </tr>
            </tbody>
        </table>
    </div>
    <div id="mywait0" style="position: absolute; top: 40%; left: 40%; z-index: 10; visibility: hidden">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td align="center">
                    <table width="300" height="100" border="1" cellspacing="0" cellpadding="0" bordercolor="#d5d5d5" bgcolor="#d5d5d5">
                        <tr>
                            <td height="24" align="center" bgcolor="#e0e0e0"></td>
                        </tr>
                        <tr>
                            <td height="80" class="kfs" align="center" bgcolor="#f5f5f5">���ڴ������Ժ�...</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <div id="div_htdoc" style="max-width: 1400px; z-index: 8; background-color: #fff; border: 1px;" contenteditable="false">

        <form method="POST" id="MyForm" name="MyForm" style="max-width: 95%; position: relative; margin: 0 auto">
            <!--#include file="../TLinc/inc_Load.aspx"-->
            <%
                dim tzid, zbid, str_sql, myselected, mycl, mytj, djlx
                dim strID, MyZbds, MyMxds, maxjls, i, jls, mx_hjje, mx_hjsl
                Dim zb_jf, zb_khmc, zb_bmmc, zb_lbmc, zb_htbh, zb_ddbh, zb_qyrq, htfl, zb_khid, zb_khfl, show_mc, zb_slvmc
                Dim zb_slv As Decimal
                dim page_first, page_prv, page_next, page_end, pagesize0, page_xz, page_no, page_ys, qsh, jsh, tg

                'MyConn = New SqlConnection("server='192.168.35.10';uid=ABEASD14AD;pwd=+AuDkDew;database=tlsoft")
                tg = Trim(Request.Form("tg"))
                if len(tg) = 0 then tg = Trim(Request.QueryString("tg"))

                tzid = session("userssid")
                zbid = Session("zbid")
                djlx = "981"    '�ӹ�����(��������)
                htfl = "1"    '��ͬ����(�ӹ���ͬ)
                jls = 0

                page_first = Trim(Request.Form("page_first"))
                if len(page_first) = 0 then page_first = Trim(Request.QueryString("page_first"))
                page_prv = Trim(Request.Form("page_prv"))
                if len(page_prv) = 0 then page_prv = Trim(Request.QueryString("page_prv"))
                page_next = Trim(Request.Form("page_next"))
                if len(page_next) = 0 then page_next = Trim(Request.QueryString("page_next"))
                page_end = Trim(Request.Form("page_end"))
                if len(page_end) = 0 then page_end = Trim(Request.QueryString("page_end"))
                pagesize0 = Trim(Request.Form("pagesize0"))
                if len(pagesize0) = 0 then pagesize0 = Trim(Request.QueryString("pagesize0"))
                if len(pagesize0) = 0 then pagesize0 = 10
                page_no = Request.Form("page_no")
                if len(page_no) = 0 then page_no = Trim(Request.QueryString("page_no"))


                strID = Trim(Request.Form("hi_id"))
                if len(strID) = 0 then strID = Trim(Request.QueryString("id"))


                '��������    
                MySql = "SELECT a.khid,b.khfl,a.slv,a.djh, Convert(varchar(10),a.rq,120) rq,b.htdf,a.bz,a.lbmc,case when b.htlx=2 then isnull(yht.htbh,a.htbh) else a.htbh end as htbh,a.ddbh,Convert(varchar(10),a.qyrq,120) qyrq,d.qymc as jf,c.mc as bmmc,e.mc slvmc "
                MySql += " FROM zw_t_htdddjb a "
                MySQL += " INNER JOIN yx_t_htgl b ON a.htbh=b.htbh "
                MySQL += " INNER JOIN T_xtdm c ON a.bmid=c.id  "
                MySQL += " INNER JOIN  yx_t_khmx d  ON  b.khfl=d.id "
                MySql += " LEFT JOIN  yx_t_htgl yht ON b.yhtid=yht.id "
                MySql += " LEFT JOIN  zw_V_htTaxRate e ON a.slv=e.slv "
                MySql += " WHERE a.tzid=" + tzid + " and b.tzid=" + tzid + " and a.djlx=" + djlx + " and a.ID='" + strID + "'   and c.djid=6   and c.tzid=" + tzid + "   "
                MyDr = MyData.MyDataRead(MyConn, MySQL)
                if session("userid") = 12742 then
                    response.write("<textarea>" + MySQL + "</textarea>")
                end if
                If Mydr.Read() Then
                    zb_khid = Mydr.Item("khid").ToString()
                    zb_khfl = Mydr.Item("khfl").ToString()
                    zb_khmc = Mydr.Item("htdf").ToString()
                    zb_bmmc = Mydr.Item("bmmc").ToString()
                    zb_lbmc = Mydr.Item("lbmc").ToString()
                    zb_ddbh = Mydr.Item("ddbh").ToString()
                    zb_htbh = Mydr.Item("htbh").ToString()
                    zb_qyrq = Mydr.Item("qyrq").ToString()
                    zb_slv = Decimal.Parse(Mydr.Item("slv").ToString())
                    zb_slvmc = Mydr.Item("slvmc").ToString()
                    zb_jf = Mydr.Item("jf").ToString()
                End If
                Mydr.Close()

                If (zb_khid = 11360 Or zb_khid = 11228) And zb_khfl <> 7398 Then
                    show_mc = "���ɣ��й������޹�˾"
                Else
                    show_mc = zb_khmc
                End If
                page_xz = Request.Form("page_xz")
                If Len(page_no) = 0 Then page_no = 1
                If page_no < 1 Or page_no > 999999999 Then page_no = 1


                '������ϸ
                MySql = "SELECT a.sphh,  sum(a.sl) sl, a.dj, sum(a.je) je,max(a.bz) bz , "
                MySql += " max(Case when a.wlksrq<>'' then Convert(varchar(10),a.wlksrq,120) else '' end) wlksrq, "
                MySql += " max(Case When a.wljsrq<>'' then Convert(varchar(10),a.wljsrq,120) else '' end) wljsrq, "
                MySql += " Case When a.cpksrq<>'' then Convert(varchar(10),a.cpksrq,120) else '' end cpksrq, "

                MySql += " max(Case When a.dhsxsj<>'' then Convert(varchar(10),a.dhsxsj,120) else '' end) dhsxsj,"
                MySql += " max(Case When a.dhypsj<>'' then Convert(varchar(10),a.dhypsj,120) else '' end) dhypsj,"
                MySql += " max(Case When a.dhyjsj<>'' then Convert(varchar(10),a.dhyjsj,120) else '' end) dhyjsj, "
                MySql += " max(Case When a.dhwlsj<>'' then Convert(varchar(10),a.dhwlsj,120) else '' end) dhwlsj, "
                MySql += " max(Case When a.smwcrq<>'' then Convert(varchar(10),a.smwcrq,120) else '' end) smwcrq, "
                MySql += " sum(a.fysl) fysl,max(case isnull(fylx,0) when 1 then 'ԤͶ����'else '��ǰ����' end ) as fylx "
                MySql += " FROM zw_t_htscddmx a  "
                '20130712 ������sphh,dj ��Ϊ sphh,dj,cpksrq(��Ʒ����)
                MySql += "   WHERE a.ID='" + strID + "'   group by a.sphh ,a.dj,a.cpksrq having   sum(isnull(a.sl,0))>0 "
                If Session("userid") = 12742 Then
                    Response.Write("<textarea>" + MySql + "</textarea>")
                End If
                MyMxds = MyData.MyDataSet(MyConn, MySql)
                jls = MyMxds.Tables(0).Rows.Count


                mx_hjje = MyMxds.Tables(0).Compute("sum(je)", "")
                mx_hjsl = MyMxds.Tables(0).Compute("sum(sl)", "")

                If jls \ pagesize0 <> jls / pagesize0 Then
                    page_ys = jls \ pagesize0 + 1
                Else
                    page_ys = jls \ pagesize0
                End If

                Select Case page_xz
                    Case "1"
                        page_no = 1
                    Case "2"
                        page_no = page_no - 1
                        If page_no < 1 Then page_no = 1
                    Case "3"
                        page_no = page_no + 1
                        If page_no > page_ys Then page_no = page_ys
                    Case "4"
                        page_no = page_ys
                End Select
            %>
            <input type="hidden" name="hi_id" value="<%=strID %>" />
            <input type="hidden" name="page_first" value="<%=page_first %>" />
            <input type="hidden" name="page_prv" value="<%=page_prv %>" />
            <input type="hidden" name="page_next" value="<%=page_next %>" />
            <input type="hidden" name="page_end" value="<%=page_end %>" />
            <input type="hidden" name="page_xz" value="<%=page_xz %>" />
            <input type="hidden" name="page_no" value="<%=page_no %>" />
            <input type="hidden" name="pagesize0" value="<%=pagesize0 %>" />
            <%
                For page_no = 1 To page_ys
                    qsh = pagesize0 * (page_no - 1)
                    jsh = pagesize0 * page_no - 1
                    If jsh >= jls Then jsh = jls - 1

            %>
            <!--������ά��ͼ��-->
            <% If page_no = "1" Then %>
            <div id="codeimg" style="right: 40px; top: 50px; position: absolute;">
                <img style="width: 70px; height: 70px;" src="../BB_apply/QrCode.aspx?c=<%=zb_ddbh%>" />
            </div>
            <%Else%>
            <%End If %>
            <div class="m4a" style="position: relative;">
                <table style="width: 100%" cellspacing="0" cellpadding="0" border="0">
                    <tr <%=iif(page_no<>"1","height=60px","") %>>
                        <td style="font-size: 16pt;" align="center"><b>����Ʒ�Ʒ��μӹ�����</b></td>
                    </tr>
                </table>
                <% if page_no = "1" then %>
                <table style="width: 100%; font-weight: bold;" cellspacing="0" cellpadding="0" border="0" class="blk">
                    <tr style="right: 20px; top: 20px; position: absolute;">
                        <td align="right" class="blk"><b>������ţ�<%=zb_ddbh%></b><span style="width: 100px;">&nbsp;</span></td>
                    </tr>
                    <tr height="20px">
                        <td align="left">�׷���<%=zb_jf %></td>
                    </tr>
                    <tr height="20px">
                        <td align="left">�ҷ���<%=show_mc%></td>
                    </tr>
                    <tr height="20px">
                        <td align="left">ǩԼʱ�䣺<% if zb_qyrq <> "" then %>
                            <%=DateTime.Parse(zb_qyrq).ToString("yyyy��MM��dd��")%>
                            <% end if %>
                        </td>
                    </tr>
                </table>
                <table border="0px" class="blk13">
                    <br>
                    <tr height="20px">
                        <td width="310px" align="left"><b>һ����Ʒ���š����������ۼ���</b></td>
                        <td width="300px" align="LEFT">�±���<�ܶ�����>�Ѱ���<��������></td>
                        <td width="200px" align="center">����:�����</td>
                        <td width="100px" align="center">��λ:Ԫ</td>
                        <td width="150px" align="right">˰��:<%=zb_slvmc %></td>
                    </tr>
                </table>
                <% end if %>

                <table border="1" cellspacing="0" cellpadding="0" bordercolordark="white" bordercolor="#000000" id="MainTable" style='width: 100%; table-layout: fixed;'>
                    <tr align="center" class="blk13 TLlm" height="35px">
                        <td rowspan="2" style="width: 10mm">���</td>
                        <td rowspan="2" style="width: 25mm">�µ�����</td>
                        <td rowspan="2" style="width: 18mm">�µ�����<br />
                            (��)</td>
                        <td rowspan="2" style="width: 16mm"><%= IIf(zb_slv = 0, "", "��˰")%>����<br />
                            (Ԫ/��)</td>
                        <td rowspan="2" style="width: 20mm"><%= IIf(zb_slv = 0, "", "��˰")%>�ϼƽ��<br />
                            (Ԫ)</td>
                        <td rowspan="2" style="width: 28mm">�������<br />
                            һ���Ե�λʱ��</td>
                        <td rowspan="2" style="width: 28mm">�������ʱ��</td>
                        <td colspan="3" style="width: 80mm">��������</td>
                        <td rowspan="2" style="width: 28mm">ˢ���������</td>
                        <td rowspan="2" style="width: 28mm">��Ʒ������</td>
                        <td rowspan="2" style="width: 30mm">�ر�Լ������</td>
                    </tr>
                    <tr align="center" class="blk13" height="35px">
                        <td style="width: 20mm">������ʽ</td>
                        <td style="width: 28mm">����ʱ��</td>
                        <td style="width: 28mm">���ϵ�λʱ��</td>
                        <%--  <td  style=" width:15mm;">����</td>            --%>
                    </tr>
                    <%for i = qsh To jsh
                            MyDr = MyMxDs.Tables(0).Rows(i)
                    %>
                    <tr class="blk13" height="25px">
                        <td align="center"><%=Cstr(Cint(i)+1)%></td>
                        <td align="center"><%=MyData.MyEmpty(MyDr.Item("sphh").ToString())%></td>
                        <td align="center"><%=MyData.MyEmpty(MyDr.Item("sl").ToString())%></td>
                        <td align="center"><%=MyData.MyEmpty(String.Format("{0:0.00}",MyDr.Item("dj")) )%></td>
                        <td align="center"><%=MyData.MyEmpty(String.Format("{0:0.00}",MyDr.Item("je")) )%></td>
                        <td align="center">
                            <%
                                if MyDr.Item("dhwlsj").ToString() <> "" then
                                    response.write(MyData.MyEmpty(DateTime.Parse(MyDr.Item("dhwlsj")).ToString("yyyy��MM��dd��")))
                                else
                                    response.write("&nbsp;")
                                end if
                            %>

                        </td>

                        <td align="center">
                            <%
                                if MyDr.Item("dhsxsj").ToString() <> "" then
                                    response.write(MyData.MyEmpty(DateTime.Parse(MyDr.Item("dhsxsj")).ToString("yyyy��MM��dd��")))
                                else
                                    response.write("&nbsp;")
                                end if
                            %>
                        </td>

                        <td align="center"><%=MyData.MyEmpty(MyDr.Item("fylx").ToString())%></td>
                        <td align="center">
                            <%
                                if MyDr.Item("dhyjsj").ToString() <> "" then
                                    response.write(MyData.MyEmpty(DateTime.Parse(MyDr.Item("dhyjsj")).ToString("yyyy��MM��dd��")))
                                else
                                    response.write("&nbsp;")
                                end if

                            %>
                        </td>
                        <td align="center">
                            <%
                                if MyDr.Item("dhypsj").ToString() <> "" then
                                    response.write(MyData.MyEmpty(DateTime.Parse(MyDr.Item("dhypsj")).ToString("yyyy��MM��dd��")))
                                else
                                    response.write("&nbsp;")
                                end if
                            %>
                        </td>
                        <td align="center">
                            <%
                                if MyDr.Item("smwcrq").ToString() = "" Then
                                    Response.Write("&nbsp;")
                                Else
                                    Response.Write(MyData.MyEmpty(DateTime.Parse(Mydr.Item("smwcrq")).ToString("yyyy��MM��dd��")))
                                End if

                            %>
                        </td>

                        <td align="center">
                            <%
                                if MyDr.Item("cpksrq").ToString() = "" then
                                    response.write("&nbsp;")
                                else
                                    response.write(MyData.MyEmpty(DateTime.Parse(MyDr.Item("cpksrq")).ToString("yyyy��MM��dd��")))
                                end if

                            %>
                        </td>
                        <td><%=MyData.MyEmpty(MyDr.Item("bz").ToString())%></td>
                    </tr>
                    <%next
                        'maxjls=jls-1
                        'if maxjls<9 then maxjls=9 
                        '20130627 ke
                        maxjls = jls
                        if maxjls < pagesize0 then maxjls = pagesize0
                        Dim myc
                        If jls < pagesize0 Then
                            '�������������<10
                            If page_ys > 1 Then
                                '�����ҳ��>1
                                myc = "hid"
                            End If
                        End If

                        For i = jls To maxjls - 1
                    %>
                    <tr class="blk13 <%=myc%>" height="25px">
                        <td width="45px" align="center"><%=CStr(CInt(i) + 1) %></td>
                        <td align="center">&nbsp;</td>
                        <td align="center">&nbsp;</td>
                        <td align="center">&nbsp;</td>
                        <td align="center">&nbsp;</td>
                        <td align="center">&nbsp;</td>
                        <td align="center">&nbsp;</td>
                        <td align="center">&nbsp;</td>
                        <td align="center">&nbsp;</td>
                        <td align="center">&nbsp;</td>
                        <td align="center">&nbsp;</td>
                        <td align="center">&nbsp;</td>
                        <td align="center">&nbsp;</td>
                    </tr>
                    <%next %>
                    <% if page_no = page_ys then %>
                    <tr class="blk13" height="35">
                        <td colspan="2" align="center" style="letter-spacing: 5px;">��&nbsp;&nbsp;��</td>
                        <td align="center"><%=MyData.MyEmpty(mx_hjsl) %></td>
                        <td>&nbsp;</td>
                        <td>
                            <input type="text" name="mx_hjje" style="width: 98%; border: 0px; text-align: center;" readonly value="<%=mx_hjje %>" /></td>
                        <td colspan="8">����ң�<span style="letter-spacing: 2px;"><%=Chinese_Format(mx_hjje)%></span>(ʵ�ʽ���Լ׷�ʵ������Ϊ׼)
                        </td>
                    </tr>
                    <% end if %>
                </table>
                <% if page_no = page_ys then %>
                <table border="0" width="100%" style="font-weight: bold;" class="blk13">
                    <tr>
                        <td align="left">��������������Ϳ�ģ������������˻�ί�д����˼����ڿ�����дǩ���⣬�����ط���д����Ч��</td>
                    </tr>
                    <tr>
                        <td align="left">����������Ҽʽ��ҳ������˫����ִҼ�ݣ���˫�����������˻� ��Ȩ��ǩ��������֮������Ч��</td>
                    </tr>
                    <tr>
                        <td align="left">�ġ�������Ϊ�ӹ�������ͬ����ͬ���<%=zb_htbh %>���ĸ���������˫��Ӧ�ϸ�����ִ�С�δ�����ˣ�˫��Э�̽����</td>
                    </tr>
                </table>
                <table border="0" width="95%" style="font-weight: bold;" class="blk13">
                    <tr height="25">
                        <td align="left" width="300px">��&nbsp;����<%=zb_jf %></td>
                        <td>&nbsp;</td>
                        <td align="left" width="300px">��&nbsp;����<%=show_mc %></td>
                    </tr>
                    <tr height="20">
                        <td align="left" width="300px">ί�д����ˣ�</td>
                        <td>&nbsp;</td>
                        <td align="left" width="300px">ί�д����ˣ�</td>
                    </tr>
                    <tr height="20">
                        <td align="left" width="300px">���£�</td>
                        <td>&nbsp;</td>
                        <td align="left" width="300px">���£�</td>
                    </tr>
                    <tr height="20">
                        <td align="left" width="300px">��ϵ�绰��</td>
                        <td>&nbsp;</td>
                        <td align="left" width="300px">��ϵ�绰��</td>
                    </tr>
                    <tr height="20">
                        <td align="left" width="300px">ǩ�����ڣ�<%=DateTime.Parse(zb_qyrq).ToString("yyyy��MM��dd��")%></td>
                        <td>&nbsp;</td>
                        <td align="left" width="300px">ǩ�����ڣ�<%=DateTime.Parse(zb_qyrq).ToString("yyyy��MM��dd��")%></td>
                    </tr>
                </table>
                <%              End If %>
                <table border="0" width="100%" style="position: absolute; bottom: 10px; right: 0; left: 0">
                    <tr hegiht="45px">
                        <td align="center" class="blk">��&nbsp;<%=CStr(page_no)%>&nbsp;ҳ&nbsp;&nbsp;��&nbsp;<%=page_ys%>&nbsp;ҳ</td>
                    </tr>
                </table>
            </div>
            <%Next

                If mycl = "edit" Then
                    MyMxds.dispose()
                End If
            %>

            <input type="hidden" id="maxjls" name="maxjls" value="<%=maxjls%>">
        </form>
    </div>
</body>

<script language="javascript" type="text/javascript" src="../TLTools/calendar.js"></script>
<script language="javascript">
    var tc = new Array();
    //���һ��cookie
    function addCookie(name, value, time) {
        var cookieString = name + "=" + escape(value);
        //�ж��Ƿ����ù���ʱ�� 
        if (time > 0) {
            var date = new Date();
            date.setTime(date.getTime + time * 3600 * 1000);
            cookieString = cookieString + "; expires=" + date.toGMTString();
        }
        document.cookie = cookieString;
    }
    //��ȡcookie
    function getCookie(name) {
        var strCookie = document.cookie;
        var arrCookie = strCookie.split("; ");
        for (var i = 0; i < arrCookie.length; i++) {
            var arr = arrCookie[i].split("=");
            if (arr[0] == name) return arr[1];
        }
        return "";
    }
    function My_Print(tg) {
        var MyURL = "yx_cl_htscdd_main.aspx?id=" + MyForm.hi_id.value + "&page_first=" + MyForm.page_first.value + "&page_prv=" + MyForm.page_prv.value + "&page_next=" + MyForm.page_next.value;
        MyURL += "&page_end=" + MyForm.page_end.value + "&pagesize0=" + MyForm.pagesize0.value + "&page_no=" + MyForm.page_no.value + "&tg=" + tg.toString();
        win_prt(MyURL).opener;
    }

    function $(id) { return document.getElementById(id); }

    function showconfig() {
        $("divInfo").style.display = "block";
    }
    function MsgClose() {
        $("divInfo").style.display = "none";
    }
    function WidthSet() {
        var sz = "", c1 = "", c2 = "", c3 = "", myid = "";
        var len = $("MainTable").rows.length - 1;//����
        var col = $("fixtab").rows.length - 1;//��������
        for (var j = 0; j < col; j++) {
            myid = $("fixtab").rows[j].cells[1].id;
            sz = $("fixtab").rows[j].cells[1].childNodes[0].value;
            if (sz.length == 0) continue;
            c1 = myid.split("_")[1];//˫��ͷ��һ���к�
            c2 = myid.split("_")[2];//�����к�
            c3 = myid.split("_")[3];//�ϲ��б�ʶ
            addCookie(myid, sz, 0);
            //alert($("fixtab").rows[j].cells[1].id);
            for (var i = 0; i < len; i++) {;
                if (sz == "0") {
                    if (c3 == "0") {
                        if (i == 0) { $("MainTable").rows[i].cells[c1].style.width = "0mm"; $("MainTable").rows[i].cells[c1].style.display = "none"; continue; }
                        if (i > 1) { $("MainTable").rows[i].cells[c2].style.width = "0mm"; $("MainTable").rows[i].cells[c2].style.display = "none"; continue; }
                    }
                    if (c3 == "1") {
                        if (i == 0 && $("MainTable").rows[1].cells[c2 - c1].style.display != "none") {
                            if ($("MainTable").rows[i].cells[c1].colSpan == "1")
                            { $("MainTable").rows[i].cells[c1].style.display = "none"; continue; }
                            $("MainTable").rows[i].cells[c1].colSpan = parseInt($("MainTable").rows[i].cells[c1].colSpan - 1); continue;
                        }
                        if (i == 1) { $("MainTable").rows[1].cells[c2 - c1].style.width = "0mm"; $("MainTable").rows[1].cells[c2 - c1].style.display = "none"; continue; }
                        if (i > 1) { $("MainTable").rows[i].cells[c2].style.width = "0mm"; $("MainTable").rows[i].cells[c2].style.display = "none"; continue; }
                    }
                }
                else {
                    if (c3 == "0") {
                        if (i == 0) { $("MainTable").rows[i].cells[c1].style.display = "block"; $("MainTable").rows[i].cells[c1].style.width = sz + "mm"; continue; }
                        if (i > 1) { $("MainTable").rows[i].cells[c2].style.display = "block"; $("MainTable").rows[i].cells[c2].style.width = sz + "mm"; continue; }
                    }
                    if (c3 == "1") {
                        if (i == 0 && $("MainTable").rows[1].cells[c2 - c1].style.display == "none") {
                            if ($("MainTable").rows[i].cells[c1].style.display != "none")
                                $("MainTable").rows[i].cells[c1].colSpan = parseInt($("MainTable").rows[i].cells[c1].colSpan + 1);
                            $("MainTable").rows[i].cells[c1].style.display = "block"; continue;
                        }
                        if (i == 1) { $("MainTable").rows[i].cells[c2 - c1].style.display = "block"; $("MainTable").rows[i].cells[c2 - c1].style.width = sz + "mm"; continue; }
                        if (i > 1) { $("MainTable").rows[i].cells[c2].style.display = "block"; $("MainTable").rows[i].cells[c2].style.width = sz + "mm"; continue; }
                    }
                }
            }
        }
        MsgClose();
    }
    function ContextMenu() {
        var myhtml = "", sz = ""; var l = 0;
        var collen = $("MainTable").rows[0].cells.length;
        myhtml += "<table id='fixtab' border='0' cellspacing='0'>";
        for (var i = 0; i < collen; i++) {
            if (tc[i] > 1) {
                for (var j = 0; j < tc[i]; j++) {
                    //alert(getCookie("sz_"+i+"_"+(i+j)+"_1")); return;
                    if (getCookie("sz_" + i + "_" + (i + j) + "_1") != "") { sz = getCookie("sz_" + i + "_" + (i + j) + "_1"); } else { sz = $("MainTable").rows[1].cells[j].style.width.replace(/mm/, ''); }
                    myhtml += "<tr><td id=col_" + i + " style='width:120px;font-size:12px'>" + $("MainTable").rows[1].cells[j].innerText + "</td>"
                    myhtml += "<td id=sz_" + i + "_" + (i + j) + "_" + "1><input class='rowVal' style='width:80px;text-align:right;' type='text' value='" + sz + "'></td>";
                    myhtml += "<td>mm</td></tr>";
                }
                l = l + j - 1;
            } else {
                if (getCookie("sz_" + i + "_" + (i + l) + "_0") != "") { sz = getCookie("sz_" + i + "_" + (i + l) + "_0"); } else { sz = $("MainTable").rows[0].cells[i].style.width.replace(/mm/, ''); }
                myhtml += "<tr><td id=col_" + i + " style='width:120px;font-size:12px'>" + $("MainTable").rows[0].cells[i].innerText + "</td>"
                myhtml += "<td id=sz_" + i + "_" + (i + l) + "_" + "0><input class='rowVal' style='width:80px;text-align:right;' type='text' value='" + sz + "'></td>"
                myhtml += "<td>mm</td></tr>";
            }
        }
        /* myhtml+="<tr><td><input type='button' style='width:120px' value='ȷ��' onClick='WidthSet()'></td><td colspan=2><input style='width:110px' onClick='MsgClose()' type='button' value='�ر�'></td></tr>"; */

        myhtml += "<tr><td><input type='button' style='width:120px' value='ȷ��' onClick='setWidth()'></td><td colspan=2><input style='width:110px' onClick='MsgClose()' type='button' value='�ر�'></td></tr>";
        myhtml += "<tr><td colspan=3 style='font-size:13px;color:red'>˵��������0��ʾ���أ��ſ�Ϊ���޸ģ���λ����!</td></tr></table>";
        $("divInfo").innerHTML = myhtml;
        $("divInfo").style.display = "block";
        return false;
    }
    window.onload = function () {
        var col = $("MainTable").rows[0].cells.length;
        for (var i = 0; i < col; i++) {
            if ($("MainTable").rows[0].cells[i].colSpan > 1) tc[i] = $("MainTable").rows[0].cells[i].colSpan;
        }
        window.document.oncontextmenu = ContextMenu;
        /* ContextMenu(); */
        /* WidthSet(); */


        /* ��ҳչʾ */
        var mainCanvas = document.getElementById('div_htdoc');
        var m4a = document.getElementsByClassName('m4a');//ҳ���ϱ��Ԫ��
        var mybottdiv = document.getElementById('mybottdiv');//������ʾ�ĵڼ�ҳ
        var mainCanvasW = mainCanvas.offsetWidth - 5;//���ͬ��Ļ�ϵĿ��

        var m4aH = (mainCanvasW * 575) / 842;//��������󣬱��Ӧ���еĸ߶�
        console.log("��ȣ�" + mainCanvasW + "�߶ȣ�" + m4aH);
        var m4aHStr = m4a[0].offsetHeight;//m4aԭʼ�ĸ߶�
        console.log(m4aHStr);
        if (m4a.length > 0) {
            for (var i = 0; i < m4a.length; i++) {
                m4a[i].style.height = m4aH;
            }
        }



        // �޸Ĺȸ���ʽ��ʧbug 20200731
        var td = document.querySelectorAll('td')
        for (var el = 0; el < td.length; el++) {
            td[el].style.display = "table-cell";
        }
        // �޸Ľ���
    }

    /* ���ÿ�� */
    function setWidth() {
        // ���ÿ�ȣ��������
        var inpVal = document.getElementsByClassName('rowVal');//���ÿ�������
        var rowTd = document.getElementsByClassName('TLlm');//tdԪ��
        console.log(rowTd.length);
        console.log(inpVal.length);
        for (var j = 0; j < rowTd.length; j++) {
            for (var i = 0; i < inpVal.length; i++) {
                rowTd[j].children[i].style.width = inpVal[i].value + 'mm';
            }
            MsgClose();
        }
    }

    function ce() {
        alert("ce sh ")
    }
</script>
</html>

