Option Explicit

'//�o���G�[�V�����Ǘ��u�b�N��
Private variationMngBookName As String
'//�o���G�[�V�����Ǘ��u�b�N�̃V�[�g��
Private variationMngSheetName As String
'//�o���G�[�V�����Ǘ��u�b�N���z�u����Ă���p�X
Private path As String
'//�^�C���X�^���v���L������Z��
Private timeStampCells As Range

Public Property Get getVariationMngBookName() As String
    getVariationMngBookName = variationMngBookName
End Property

Public Property Get getVariationMngSheetName() As String
    getVariationMngSheetName = variationMngSheetName
End Property

Public Property Get getPath() As String
    getPath = path
End Property

Public Property Get getTimeStampCells() As Range
    getTimeStampCells = timeStampCells
End Property

Public Property Let setVariationMngBookName(ByVal newVariationMngBookName As String)
    variationMngBookName = newVariationMngBookName
End Property

Public Property Let setVariationMngSheetName(ByVal newVariationMngSheetName As String)
    variationMngSheetName = newVariationMngSheetName
End Property

Public Property Let setPath(ByVal newPath As String)
    path = newPath
End Property

Public Property Set setTimeStampCells(ByVal newTimeStampCells As Range)
    timeStampCells = newTimeStampCells
End Property
    
