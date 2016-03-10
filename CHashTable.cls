VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CHashTable"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'//////////////////////////////////////////////////////////////////////////////
'@@summary
'@@require
'@@reference
'@@license
'@@author
'@@create
'@@modify
'//////////////////////////////////////////////////////////////////////////////
'���ڲ�����һ�����顿

'//////////////////////////////////////////////////////////////////////////////
'//
'//      ��������
'//
'//////////////////////////////////////////////////////////////////////////////


'------------------------------------------------------------------------------
'       �ӿڼ̳�
'------------------------------------------------------------------------------


'------------------------------------------------------------------------------
'       ���г���
'------------------------------------------------------------------------------


'------------------------------------------------------------------------------
'       ������������
'------------------------------------------------------------------------------


'------------------------------------------------------------------------------
'       ���б���
'------------------------------------------------------------------------------


'------------------------------------------------------------------------------
'       ����API
'------------------------------------------------------------------------------


'------------------------------------------------------------------------------
'       �¼�����
'------------------------------------------------------------------------------


'//////////////////////////////////////////////////////////////////////////////
'//
'//      ˽������
'//
'//////////////////////////////////////////////////////////////////////////////


'------------------------------------------------------------------------------
'       ˽�г���
'------------------------------------------------------------------------------
Private Const INIT_SIZE = 1024
Private Const INIT_GAP_SIZE = 128

'------------------------------------------------------------------------------
'       ˽����������
'------------------------------------------------------------------------------
Private Type ArrayElement
  IsTaken As Boolean
  value As Variant
  key As String
End Type


'------------------------------------------------------------------------------
'       ˽�б���
'------------------------------------------------------------------------------
Private mCount As Long
Private mCurrentSize As Long
Private mArray() As ArrayElement
Private mSize As Long
Private mGapSize As Long


'------------------------------------------------------------------------------
'       ���Ա���
'------------------------------------------------------------------------------


'------------------------------------------------------------------------------
'       ˽��API
'------------------------------------------------------------------------------


'//////////////////////////////////////////////////////////////////////////////
'//
'//      ��
'//
'//////////////////////////////////////////////////////////////////////////////


'------------------------------------------------------------------------------
'       ��ʼ��
'------------------------------------------------------------------------------
Private Sub Class_Initialize()
  resizeArray INIT_SIZE
  Me.GapSize = INIT_GAP_SIZE
End Sub


'------------------------------------------------------------------------------
'       ����
'------------------------------------------------------------------------------
Private Sub Class_Terminate()

End Sub


'//////////////////////////////////////////////////////////////////////////////
'//
'//      �¼�����
'//
'//////////////////////////////////////////////////////////////////////////////


'//////////////////////////////////////////////////////////////////////////////
'//
'//      ˽������
'//
'//////////////////////////////////////////////////////////////////////////////


'//////////////////////////////////////////////////////////////////////////////
'//
'//      ˽�з���
'//
'//////////////////////////////////////////////////////////////////////////////
Private Sub resizeArray(ByVal newSize As Long)
  If mCount > 0 Then
    ReDim Preserve mArray(1 To newSize)
  Else
    ReDim mArray(1 To newSize)
  End If
  mCurrentSize = newSize
End Sub

Private Sub rearangeArray()
  '���ȴ�ʩ����
  'if data exists on 1,5,9,11,....so on,which means data are ranging almost randomly,
  'we need to call this sub to rearrange it
  
End Sub

Private Sub expandArray()
  mCurrentSize = mCurrentSize + mGapSize
  resizeArray mCurrentSize
End Sub

Private Function findIndex(ByVal keyword As String) As Long
  Dim index As Long, startIndex As Long
  index = calcInitIndex(keyword)
  
  startIndex = index
  GoTo DirectExec
MoveOn:
  If startIndex = index Then
    findIndex = -1
    Exit Function
  End If
DirectExec:
  If mArray(index).IsTaken = True And mArray(index).key = keyword Then
    findIndex = index
    Exit Function
  Else
    index = (index + 1) Mod mCurrentSize
    If index = 0 Then index = index + 1
    GoTo MoveOn
  End If
End Function

Private Function findFreeIndex(ByVal keyword As String) As Long
  Dim index As Long, startIndex As Long
  index = calcInitIndex(keyword)
  
  startIndex = index
  GoTo DirectExec
MoveOn:
  If startIndex = index Then
    findFreeIndex = -1
    Exit Function
  End If
DirectExec:
  If mArray(index).IsTaken = False Then
    findFreeIndex = index
    Exit Function
  Else
    index = (index + 1) Mod mCurrentSize
    If index = 0 Then index = index + 1
    GoTo MoveOn
  End If
End Function


Private Function calcInitIndex(ByVal keyword As String) As Long
  Dim index As Long, i As Long
  Dim bytes() As Byte
  bytes = keyword
  For i = LBound(bytes) To UBound(bytes)
    index = index + bytes(i)
    If index > mCount Then
      index = index Mod mCurrentSize
    End If
  Next i
  If index = 0 Then index = index + 1
  calcInitIndex = index
End Function


'//////////////////////////////////////////////////////////////////////////////
'//
'//      �̳�ʵ��
'//
'//////////////////////////////////////////////////////////////////////////////


'//////////////////////////////////////////////////////////////////////////////
'//
'//      ��������
'//
'//////////////////////////////////////////////////////////////////////////////
Property Get GapSize() As Long
  GapSize = mGapSize
End Property
Property Let GapSize(ByVal newValue As Long)
  If mCount > 0 Then
    Err.Raise 1000, , "[SunSoft]�Ѿ������ݣ����������������޸�"
  End If
  If newValue <= 0 Then
    Err.Raise 1001, , "[SunSoft]��������������Ϊ����"
  End If
  mGapSize = newValue
End Property


'//////////////////////////////////////////////////////////////////////////////
'//
'//      ���з���
'//
'//////////////////////////////////////////////////////////////////////////////


Public Sub Add(ByVal key As String, ByVal value As Variant)
  Dim index As Long
  
  If findIndex(key) > 0 Then
    Err.Raise 1002, , "[SunSoft]�ؼ����ظ����޷�����"
  End If
  index = findFreeIndex(key)
  If index < 0 Then
    Call expandArray
    index = findFreeIndex(key)
  End If
  mArray(index).IsTaken = True
  mArray(index).key = key
  mArray(index).value = value
End Sub

Public Property Get Item(ByVal key As String) As Variant
  Dim index As Long
  index = findIndex(key)
  Item = mArray(index).value
End Property

Public Property Let Item(ByVal key As String, value As Variant)
  Dim index As Long
  
  index = findIndex(key)
  
  If index > 0 Then
    mArray(index).IsTaken = True
    mArray(index).key = key
    mArray(index).value = value
    Exit Property
  End If
  index = findFreeIndex(key)
  If index < 0 Then
    Call expandArray
    index = findFreeIndex(key)
  End If
  mArray(index).IsTaken = True
  mArray(index).key = key
  mArray(index).value = value
End Property