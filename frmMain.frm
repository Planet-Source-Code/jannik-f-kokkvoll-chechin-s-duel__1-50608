VERSION 5.00
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "CheChin's Duel"
   ClientHeight    =   6075
   ClientLeft      =   210
   ClientTop       =   0
   ClientWidth     =   10245
   Icon            =   "frmMain.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   6075
   ScaleWidth      =   10245
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame fra2 
      Height          =   855
      Left            =   7920
      TabIndex        =   5
      Top             =   0
      Width           =   2175
      Begin VB.CommandButton cmdMinus 
         Caption         =   "-"
         Height          =   255
         Left            =   120
         TabIndex        =   9
         Top             =   480
         Width           =   255
      End
      Begin VB.CommandButton cmdPlus 
         Caption         =   "+"
         Height          =   255
         Left            =   960
         TabIndex        =   8
         Top             =   480
         Width           =   255
      End
      Begin VB.TextBox txtLimit 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   480
         TabIndex        =   6
         Text            =   "10"
         Top             =   480
         Width           =   375
      End
      Begin VB.Label lblBlueS 
         Caption         =   "Blue: 0"
         Height          =   255
         Left            =   1440
         TabIndex        =   11
         Top             =   240
         Width           =   615
      End
      Begin VB.Label lblRedS 
         Caption         =   "Red: 0"
         Height          =   255
         Left            =   1440
         TabIndex        =   10
         Top             =   480
         Width           =   615
      End
      Begin VB.Label blbLimit 
         Caption         =   "Score Limit:"
         Height          =   255
         Left            =   120
         TabIndex        =   7
         Top             =   240
         Width           =   975
      End
   End
   Begin VB.Frame fra1 
      Height          =   855
      Left            =   120
      TabIndex        =   1
      Top             =   0
      Width           =   2055
      Begin VB.HScrollBar srlSpeed 
         Height          =   255
         Left            =   120
         Max             =   5
         Min             =   50
         TabIndex        =   2
         Top             =   480
         Value           =   20
         Width           =   975
      End
      Begin VB.Label lblSpeed 
         Caption         =   "Game Speed:"
         Height          =   255
         Left            =   120
         TabIndex        =   4
         Top             =   240
         Width           =   975
      End
      Begin VB.Label lblFPS 
         Caption         =   "FPS: 0"
         ForeColor       =   &H00808080&
         Height          =   255
         Left            =   1200
         TabIndex        =   3
         Top             =   360
         Width           =   735
      End
   End
   Begin VB.PictureBox picB 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      FillColor       =   &H00FFFFFF&
      ForeColor       =   &H80000008&
      Height          =   5000
      Left            =   120
      ScaleHeight     =   331
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   665
      TabIndex        =   0
      Top             =   960
      Width           =   10000
   End
   Begin VB.Label lblLogo 
      Alignment       =   2  'Center
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "CheChin's Duel"
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   27
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   760
      Left            =   2280
      TabIndex        =   12
      Top             =   90
      Width           =   5535
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'|  CheChin's Duel!  |
'| Have fun with it! |

Option Explicit

'let's do some api!
Private Declare Function DesktopHwnd Lib "user32" Alias "GetDesktopWindow" () As Long
Private Declare Function GetWindowRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long
Private Declare Function ClipCursor Lib "user32" (lpRect As Any) As Long
Private Declare Function LoadImage Lib "user32" Alias "LoadImageA" (ByVal hInst As Long, ByVal lpsz As String, ByVal un1 As Long, ByVal n1 As Long, ByVal n2 As Long, ByVal un2 As Long) As Long
Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hdc As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Private Declare Function Tick Lib "kernel32" Alias "GetTickCount" () As Long
Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

'let's make api vars!
Private Const IMAGE_BITMAP As Long = 0
Private Const LR_LOADFROMFILE As Long = &H10
Private Const LR_CREATEDIBSECTION As Long = &H2000
Private Const LR_DEFAULTSIZE As Long = &H40

Private Type RECT
    Left As Long
    right As Long
    top As Long
    bottom As Long
End Type

Dim m_Clip_o As RECT
Dim m_Clip As RECT

' the "Help" text... very important :\
Const HelpString As String = "General:" & vbCrLf & _
                             vbCrLf & _
                             "The mouse is trapped inside" & vbCrLf & _
                             "the playing field when playing," & vbCrLf & _
                             "but is released when paused." & vbCrLf & _
                             vbCrLf & _
                             "The goal is to take the ball" & vbCrLf & _
                             "and shoot it into the oponents goal." & vbCrLf & _
                             vbCrLf & _
                             "Keyboard:" & vbCrLf & _
                             vbCrLf & _
                             "ESC - Pause and release mouse" & vbCrLf & _
                             "F1 - Help" & vbCrLf & _
                             "UP - Move up" & vbCrLf & _
                             "Left - Move left" & vbCrLf & _
                             "Right - Move right" & vbCrLf & _
                             "Down - Move down" & vbCrLf & _
                             vbCrLf & _
                             "Mouse:" & vbCrLf & _
                             vbCrLf & _
                             "Button 1 - Shoot or 'unpause'"


'hi, i'm the player type!
Private Type typPlayer
    x As Double
    y As Double
    ox As Double
    oy As Double
    dx As Single
    dy As Single
    ctrl As Byte
    mx As Double
    my As Double
    score As Long
End Type

'hi! let's make ball types!
Private Type typBall
    x As Double
    y As Double
    dx As Single
    dy As Single
    carrier As Byte
    avoid As Byte
End Type

Dim Player(1) As typPlayer
Dim Ball As typBall

'the control bytes
Const c_LEFT As Byte = 1
Const c_RIGHT As Byte = 2
Const c_UP As Byte = 4
Const c_DOWN As Byte = 8
Const c_SHOOT As Byte = 16

'movement stuff
Const m_SHOOT = 10
Const m_ACCEL = 1
Const m_DCCEL = 0.9
Const m_CDACC = 0.8
Const m_BDACC = 0.99
Const m_BLOSS = 0.9
Const m_CRASH = 23

'ball stuff
Const b_PULL = 30
Const b_GET = 20
Const b_AVOID = 40
Const b_GRAV = 1.5

Const NO As Byte = 255

'timing stuff
Dim lTime As Long
Dim tTime As Long
Dim tIndex As Long

'fps stuff
Dim fpsTime As Long
Dim fpsCount As Long
Dim fpsFinal As Long

'i love one night stands
Dim tI As Long
Dim tJ As Long
Dim tX As Double
Dim tX2 As Double
Dim tX3 As Double
Dim tY As Double
Dim tY2 As Double
Dim tY3 As Double
Dim tDbl As Double
Dim tDbl2 As Double
Dim tLng As Long
Dim tSgl As Single

'dah...
Dim FieldW As Long
Dim FieldH As Long

'memory dc's, for faster blt'ing...
Dim GFX_DC As Long
Dim BUFFER_DC As Long

'math stuff :(
Const Pi = 3.14159265358979
Const hPi = Pi / 2
Const Rad90 = 1.5707963267949
Const Rad270 = 4.71238898038469
Const Rad360 = 6.28318530717958

'oi
Dim Pause As Boolean

'the button for decreasing the score limit
Private Sub cmdMinus_Click()

    If Val(txtLimit) > 0 Then txtLimit = Val(txtLimit) - 1 ' - 1? wow

End Sub

'the button for increasing the score limit
Private Sub cmdPlus_Click()

    If Val(txtLimit) < 99 Then txtLimit = Val(txtLimit) + 1 ' + 1? magic

End Sub

'eek, a button has been pushed!
Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)

    If KeyCode = vbKeyLeft Then Player(0).ctrl = Player(0).ctrl Or c_LEFT
    If KeyCode = vbKeyRight Then Player(0).ctrl = Player(0).ctrl Or c_RIGHT
    If KeyCode = vbKeyUp Then Player(0).ctrl = Player(0).ctrl Or c_UP
    If KeyCode = vbKeyDown Then Player(0).ctrl = Player(0).ctrl Or c_DOWN

    If KeyCode = vbKeyEscape Then Pause = True
    If KeyCode = vbKeyF1 Then MsgBox HelpString, vbQuestion, "Help"

End Sub

'eek, a button is pushed- no more!
Private Sub Form_KeyUp(KeyCode As Integer, Shift As Integer)

    If KeyCode = vbKeyLeft Then If (Player(0).ctrl And c_LEFT) Then Player(0).ctrl = Player(0).ctrl Xor c_LEFT
    If KeyCode = vbKeyRight Then If (Player(0).ctrl And c_RIGHT) Then Player(0).ctrl = Player(0).ctrl Xor c_RIGHT
    If KeyCode = vbKeyUp Then If (Player(0).ctrl And c_UP) Then Player(0).ctrl = Player(0).ctrl Xor c_UP
    If KeyCode = vbKeyDown Then If (Player(0).ctrl And c_DOWN) Then Player(0).ctrl = Player(0).ctrl Xor c_DOWN
    
End Sub

Private Sub Form_Load()

    Main
    
End Sub

Sub Main()

    'first we initialize this and that!
    
    tIndex = 20 'the delay index / interval / whatever
    
    'the backbuffer dc, for double buffering (faster :p)
    Dim t_BM As Long
    Dim t_DC As Long
    BUFFER_DC = CreateCompatibleDC(picB.hdc)
    t_BM = CreateCompatibleBitmap(picB.hdc, 665, 331)
    t_DC = SelectObject(BUFFER_DC, t_BM)
    DeleteObject t_BM
    
    'load up the graphics to a memory dc (faster also)
    Dim gfxFile As String
    gfxFile = App.Path & IIf(right(App.Path, 1) = "\", "gfx.bmp", "\gfx.bmp")
    GFX_DC = GenerateDC(gfxFile)
    
    'set the... ehm
    FieldW = picB.ScaleWidth
    FieldH = picB.ScaleHeight
    
    'show the form
    Me.Show
    DoEvents ' <- important, cause of the endless loop
    
    'reset the game, to start a new round
    Restart
    
    'go highwire
    Do

        'div stuff :p
        DoDiv
        
        'am i paused?
        If Not Pause Then
            'nope, do this
            fpsCheck ' check FPS
            AI ' handle the AI
            DoAll ' everything else (movement, collisions, etc.)
        End If

        'display it all
        DrawAll
        
        'slow it down... Zzzz...
        dLay
        
    'again!
    Loop
    

End Sub

'div stuff..
Function DoDiv()
    
    If Pause Then
        tLng = DesktopHwnd() 'get the desktop window
    Else
        tLng = picB.hwnd 'get the playing fields window
    End If
    
    GetWindowRect tLng, m_Clip 'get the rectangular of the chosen window
    
    'is it the same as the old window?
    If (m_Clip.Left <> m_Clip_o.Left) Or _
        (m_Clip.top <> m_Clip_o.top) Or _
        (m_Clip.right <> m_Clip_o.right) Or _
        (m_Clip.bottom <> m_Clip_o.bottom) Then
        'nope! reset the cursor boundreys
        ClipCursor m_Clip
        m_Clip = m_Clip_o
    End If

End Function

'new round folks, gather around!
Function Restart()

    'heh..
    lblBlueS.Caption = "Blue: " & Player(0).score
    lblRedS.Caption = "Red: " & Player(1).score
    
    'someone won?
    If Player(0).score >= Val(txtLimit) Then 'did I win??
        MsgBox "Blue player won!", vbInformation, "Winner!"
        Player(0).score = 0
        Player(1).score = 0
        lblBlueS = "Blue: 0"
        lblRedS = "Red: 0"
    ElseIf Player(1).score >= Val(txtLimit) Then 'no, but did I win???
        MsgBox "Red player won!", vbInformation, "Winner!"
        Player(0).score = 0
        Player(1).score = 0
        lblBlueS = "Blue: 0"
        lblRedS = "Red: 0"
    End If

    'reset the players X coordinates
    Player(0).x = 100
    Player(1).x = FieldW - 100
    
    'reset the players everything else
    For tI = 0 To 1
        Player(tI).y = FieldH / 2
        Player(tI).dx = 0
        Player(tI).dy = 0
        Player(tI).ctrl = 0
    Next tI

    'reset the ball
    Ball.x = FieldW / 2
    Ball.y = FieldH / 2
    Ball.dx = 0
    Ball.dy = 0
    Ball.avoid = NO
    Ball.carrier = NO
    
End Function

'let's pretend we are robots
Function AI()

    'does the bot have the ball?
    If Ball.carrier = 1 Then
        'if he is on his side of the field
        If Player(1).x > (FieldW / 2) Then
            Player(1).ctrl = Player(1).ctrl Or c_LEFT 'go left
            If Player(1).ctrl And c_RIGHT Then Player(1).ctrl = Player(1).ctrl Xor c_RIGHT

            'if on the bottom half of the field
            If Player(1).y > (FieldH / 2) Then
                'if not lower than 3/4th of the field
                If Player(1).y < (FieldH / 4) * 3 Then
                    
                    If Player(1).ctrl And c_SHOOT Then Player(1).ctrl = Player(1).ctrl Xor c_SHOOT
                    
                    'avoid the other player a little
                    If Player(0).y < Player(1).y Then 'gosh, the other player is above me!
                        If Player(1).ctrl And c_UP Then Player(1).ctrl = Player(1).ctrl Xor c_UP
                        Player(1).ctrl = Player(1).ctrl Or c_DOWN 'go down
                    Else
                        If Player(1).ctrl And c_DOWN Then Player(1).ctrl = Player(1).ctrl Xor c_DOWN
                        Player(1).ctrl = Player(1).ctrl Or c_UP 'go up
                    End If
                        
                Else
                    
                    'shoot down (bounce), maybe
                    Player(1).mx = Player(1).x + Player(1).dx
                    Player(1).my = Player(1).y + 50
                    
                    If Player(1).y < (FieldH - b_AVOID) + Player(1).dy Then 'make sure he'll get it back
                        Player(1).ctrl = Player(1).ctrl Or c_SHOOT
                    End If
                    
                End If
            'if on the top half field
            Else
                'if not higher than 1/4th of the field
                If Player(1).y > (FieldH / 4) Then

                    If Player(1).ctrl And c_SHOOT Then Player(1).ctrl = Player(1).ctrl Xor c_SHOOT
                     
                     'avoid the other player a little
                    If Player(0).y < Player(1).y Then 'gosh, the other player is above me!
                        If Player(1).ctrl And c_UP Then Player(1).ctrl = Player(1).ctrl Xor c_UP
                        Player(1).ctrl = Player(1).ctrl Or c_DOWN 'go down
                    Else
                        If Player(1).ctrl And c_DOWN Then Player(1).ctrl = Player(1).ctrl Xor c_DOWN
                        Player(1).ctrl = Player(1).ctrl Or c_UP 'go up
                    End If
                
                Else
                    
                    'shoot up (bounce), maybe
                    Player(1).mx = Player(1).x + Player(1).dx
                    Player(1).my = Player(1).y - 50
                    
                    If Player(1).y > b_AVOID + Player(1).dy Then 'make sure he'll get it back
                        Player(1).ctrl = Player(1).ctrl Or c_SHOOT
                    End If
                    
                End If
            End If
        'if his on the other side
        Else
            
            If Player(1).ctrl And c_SHOOT Then Player(1).ctrl = Player(1).ctrl Xor c_SHOOT

            'if im on the first 1/4th of the field
            If Player(1).x < (FieldW / 3) Then
            
                'shoot at the goal, if the oponent is out of the way
                Player(1).mx = Player(1).dx * 10
                Player(1).my = (FieldH / 2) - (Player(1).y - (FieldH / 2)) - (Player(1).dy * 20)
                
                tDbl = -Atan2(Player(1).x - Player(1).mx, Player(1).y - Player(1).my) + Rad90 'angle between him, and his "cursor"
                tDbl2 = -Atan2(Player(1).x - Player(0).x, Player(1).y - Player(0).y) + Rad90 'angle between him, and you
                tSgl = RadDiff(tDbl, tDbl2) 'the differense between the angles
                
                If Abs(tSgl) > 10 * Pi / 180 Then 'is it more then 10 degrees differense?
                    Player(1).ctrl = Player(1).ctrl Or c_SHOOT 'yes! shoot!
                End If

            End If
            
            'if his on the bottom half
            If Player(1).y > (FieldH / 3) * 2 Then
           
                If Player(1).ctrl And c_DOWN Then Player(1).ctrl = Player(1).ctrl Xor c_DOWN
                Player(1).ctrl = Player(1).ctrl Or c_UP 'go up
                
            'if his on the top half
            ElseIf Player(1).y < (FieldH / 3) Then
           
                If Player(1).ctrl And c_UP Then Player(1).ctrl = Player(1).ctrl Xor c_UP
                Player(1).ctrl = Player(1).ctrl Or c_DOWN 'go down
                
            'somewhere in the middle
            ElseIf Player(1).y > (FieldH / 3) And Player(1).y < (FieldH / 3) * 2 Then
            
                If Player(0).x < Player(1).x Then
                
                    'avoid the other player a little
                    If Player(0).y < Player(1).y Then 'gosh, the other player is above me!
                        If Player(1).ctrl And c_UP Then Player(1).ctrl = Player(1).ctrl Xor c_UP
                        Player(1).ctrl = Player(1).ctrl Or c_DOWN 'go down
                    ElseIf Player(0).y > Player(1).y Then 'no! he's bellow me!
                        If Player(1).ctrl And c_DOWN Then Player(1).ctrl = Player(1).ctrl Xor c_DOWN
                        Player(1).ctrl = Player(1).ctrl Or c_UP 'go up
                    End If
                    
                End If
                
            End If

        End If
        
    'the bot doesnt have the ball
    Else
    
        'avoided by ball?
        If Ball.avoid = 1 Then
                
            'move away from it
            If Ball.x < Player(1).x Then
                If Player(1).ctrl And c_LEFT Then Player(1).ctrl = Player(1).ctrl Xor c_LEFT
                Player(1).ctrl = Player(1).ctrl Or c_RIGHT
            Else
                If Player(1).ctrl And c_RIGHT Then Player(1).ctrl = Player(1).ctrl Xor c_RIGHT
                Player(1).ctrl = Player(1).ctrl Or c_LEFT
            End If
            If Ball.y < Player(1).x Then
                If Player(1).ctrl And c_UP Then Player(1).ctrl = Player(1).ctrl Xor c_UP
                Player(1).ctrl = Player(1).ctrl Or c_DOWN
            Else
                If Player(1).ctrl And c_DOWN Then Player(1).ctrl = Player(1).ctrl Xor c_DOWN
                Player(1).ctrl = Player(1).ctrl Or c_UP
            End If
            
        Else
    
            'go for the ball!
            
            'simplistic chasing
            If Ball.x < Player(1).x Then 'left side? go left!
                If Player(1).ctrl And c_RIGHT Then Player(1).ctrl = Player(1).ctrl Xor c_RIGHT
                Player(1).ctrl = Player(1).ctrl Or c_LEFT
            Else                         'right side? go right!
                If Player(1).ctrl And c_LEFT Then Player(1).ctrl = Player(1).ctrl Xor c_LEFT
                Player(1).ctrl = Player(1).ctrl Or c_RIGHT
            End If
            If Ball.y < Player(1).y Then 'above? go up!
                If Player(1).ctrl And c_DOWN Then Player(1).ctrl = Player(1).ctrl Xor c_DOWN
                Player(1).ctrl = Player(1).ctrl Or c_UP
            Else                         'below? go down!
                If Player(1).ctrl And c_UP Then Player(1).ctrl = Player(1).ctrl Xor c_UP
                Player(1).ctrl = Player(1).ctrl Or c_DOWN
            End If
            '-------------------
        End If
        
    End If

End Function

Function DrawAll()

    'cover the whole thing with the grass picture
    BitBlt BUFFER_DC, 0, 0, 665, 331, GFX_DC, 0, 25, vbSrcCopy

    'draw the two player things
    For tI = 0 To 1
    
        BitBlt BUFFER_DC, Player(tI).x - 12.5, Player(tI).y - 12.5, 25, 25, GFX_DC, 50, 0, vbSrcPaint
        BitBlt BUFFER_DC, Player(tI).x - 12.5, Player(tI).y - 12.5, 25, 25, GFX_DC, tI * 25, 0, vbSrcAnd

    Next tI

    'draw the ball
    BitBlt BUFFER_DC, Ball.x - 5, Ball.y - 5, 10, 10, GFX_DC, 85, 0, vbSrcPaint
    BitBlt BUFFER_DC, Ball.x - 5, Ball.y - 5, 10, 10, GFX_DC, 75, 0, vbSrcAnd
    
    'blt it onto the picturebox so we can see it
    BitBlt picB.hdc, 0, 0, 665, 331, BUFFER_DC, 0, 0, vbSrcCopy
    
End Function

'$@$€£{[€] ah
Function DoAll()

    For tI = 0 To 1

        'controls and deltas
        
        If Player(tI).ctrl And c_LEFT Then 'left
            Player(tI).dx = Player(tI).dx - m_ACCEL
        End If
        If Player(tI).ctrl And c_RIGHT Then 'right
            Player(tI).dx = Player(tI).dx + m_ACCEL
        End If
        If Player(tI).ctrl And c_UP Then 'up
            Player(tI).dy = Player(tI).dy - m_ACCEL
        End If
        If Player(tI).ctrl And c_DOWN Then 'down
            Player(tI).dy = Player(tI).dy + m_ACCEL
        End If
        If Player(tI).ctrl And c_SHOOT Then 'shoot
            If Ball.carrier = tI Then
                tDbl = -Atan2(Player(tI).mx - Player(tI).x, Player(tI).my - Player(tI).y) + Rad90
                Ball.carrier = NO
                Ball.avoid = tI
                Ball.dx = (Cos(tDbl) * m_SHOOT) + Player(tI).dx
                Ball.dy = (Sin(tDbl) * m_SHOOT) + Player(tI).dy
                Player(tI).dx = Player(tI).dx - (Cos(tDbl) * m_SHOOT)
                Player(tI).dy = Player(tI).dy - (Sin(tDbl) * m_SHOOT)
            End If
        End If
        
        'collision and movement
        tX = Player(tI).x + Player(tI).dx
        If tX <= 0 Or tX >= picB.ScaleWidth Then Player(tI).dx = -(Player(tI).dx * m_BLOSS)
        Player(tI).ox = Player(tI).x
        Player(tI).x = Player(tI).x + Player(tI).dx
        tY = Player(tI).y + Player(tI).dy
        If tY <= 0 Or tY >= picB.ScaleHeight Then Player(tI).dy = -(Player(tI).dy * m_BLOSS)
        Player(tI).oy = Player(tI).y
        Player(tI).y = Player(tI).y + Player(tI).dy
        
        'player crash
        For tJ = 0 To 1
            If tJ <> tI Then
                tDbl = Sqr((Player(tI).x - Player(tJ).x) ^ 2 + (Player(tI).y - Player(tJ).y) ^ 2)
                If tDbl < m_CRASH Then
                    
                    If Ball.carrier = tI Then
                        Ball.carrier = NO
                        Ball.avoid = tI
                        Ball.dx = Player(tJ).dx
                        Ball.dy = Player(tJ).dy
                    End If
                    If Ball.carrier = tJ Then
                        Ball.carrier = NO
                        Ball.avoid = tJ
                        Ball.dx = Player(tI).dx
                        Ball.dy = Player(tI).dy
                    End If
                    
                    tSgl = -Atan2(Player(tI).x - Player(tJ).x, Player(tI).y - Player(tJ).y) - Rad90
                    
                    tX = Cos(tSgl)
                    tY = Sin(tSgl)
                    tX2 = Player(tI).dx - Player(tJ).dx
                    tY2 = Player(tI).dy - Player(tJ).dy
                    tSgl = (tX * tX2) + (tY * tY2)

                    Player(tI).dx = Player(tI).dx - (tSgl * tX)
                    Player(tI).dy = Player(tI).dy - (tSgl * tY)
                    Player(tJ).dx = Player(tJ).dx + (tSgl * tX)
                    Player(tJ).dy = Player(tJ).dy + (tSgl * tY)
                    
                    Player(tJ).x = Player(tJ).x + Player(tJ).dx
                    Player(tJ).y = Player(tJ).y + Player(tJ).dy
                    
                End If
            End If
        Next tJ
        
        'decrease the speed- decrease more if he has the ball
        If Ball.carrier = tI Then tSgl = m_CDACC Else tSgl = m_DCCEL
        Player(tI).dx = Player(tI).dx * tSgl
        Player(tI).dy = Player(tI).dy * tSgl
           
    Next tI
    
    'ball movement etc.
    If Ball.carrier < NO Then 'one has the ball, put it on that player
        Ball.x = Player(Ball.carrier).x
        Ball.y = Player(Ball.carrier).y
    Else 'move it- crash it- deal with it
        tX = Ball.x + Ball.dx
        If tX <= 0 Then
            If Ball.y > 110 And Ball.y < 220 Then
                'it's inside the red scoring field
                Player(1).score = Player(1).score + 1
                Restart
            Else
                'not in the scoring field, just bounce it off
                Ball.dx = -(Ball.dx * m_BLOSS)
            End If
        ElseIf tX >= picB.ScaleWidth Then
            If Ball.y > 110 And Ball.y < 220 Then
                'it's inside the blue scoring field
                Player(0).score = Player(0).score + 1
                Restart
            Else
                'nope, no goal. bounce it off
                Ball.dx = -(Ball.dx * m_BLOSS)
            End If
        End If
        Ball.x = Ball.x + Ball.dx 'mooove it horizontaly
        
        tY = Ball.y + Ball.dy
        'did it crash? if so then- BOUNCE BABY!
        If tY <= 0 Or tY >= picB.ScaleHeight Then Ball.dy = -(Ball.dy * m_BLOSS)
        Ball.y = Ball.y + Ball.dy 'mooove it
        
        'ball and player stuff
        For tI = 0 To 1
        
            tDbl = Sqr((Ball.x - Player(tI).x) ^ 2 + (Ball.y - Player(tI).y) ^ 2)
            If Ball.avoid <> tI Then 'does the ball like me?
                'is the ball sooo close to the player?
                If tDbl < b_PULL Then
                    If tDbl > b_GET Then
                    
                        'it's in the zone! grav- go get it!
                        tSgl = -Atan2(Player(tI).x - Ball.x, Player(tI).y - Ball.y) + Rad90
                        tX = Cos(tSgl) * b_GRAV
                        tY = Sin(tSgl) * b_GRAV
                        
                        Ball.dx = Ball.dx + tX
                        Ball.dy = Ball.dy + tY
                    
                    Else
                    
                        'darn, too close... got it
                        Ball.carrier = tI
                        Ball.avoid = NO
                        
                    End If
                End If
            Else
                If tDbl > b_AVOID Then
                    Ball.avoid = NO 'haha, no more avoidance
                End If
            End If
            
        Next tI
        
        'total breakage!
        Ball.dx = Ball.dx * m_BDACC
        Ball.dy = Ball.dy * m_BDACC
    End If
        
End Function

Function fpsCheck()

    fpsCount = fpsCount + 1 '1 more frame mom! pleeeeease!
    
    If Tick > fpsTime Then
        fpsFinal = fpsCount
        lblFPS = "FPS: " & fpsFinal 'show the FPS
        fpsCount = 0
        fpsTime = Tick + 1000
    End If

End Function

Function dLay() 'this is suposed to slow things down...

    DoEvents
    
    tTime = tIndex - (Tick - lTime)
    If tTime > 0 Then
        Sleep tTime
    End If
    lTime = Tick
    
End Function

Private Sub Form_Unload(Cancel As Integer)

    End 'the big END! touch me
    
End Sub

Private Sub picB_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    
    If Button = 1 Then
    
        If Pause Then
            Pause = False
        Else
            Player(0).ctrl = Player(0).ctrl Or c_SHOOT 'oi, did i hit anything?
        End If
    
    End If
    
End Sub

Private Sub picB_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)

    'aim mister!
    Player(0).mx = x
    Player(0).my = y

End Sub

'a function to create a memory dc from a bitmap
Public Function GenerateDC(FileName As String) As Long
    
    Dim t_BM As Long
    Dim t_DC As Long
    t_DC = CreateCompatibleDC(picB.hdc)
    t_BM = LoadImage(0, FileName, IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE Or LR_LOADFROMFILE Or LR_CREATEDIBSECTION)
    SelectObject t_DC, t_BM
    DeleteObject t_BM
    GenerateDC = t_DC

End Function

'calculate radians.. don't ask
Public Function Atan2(y As Double, x As Double) As Double ' :\

    If x = 0 Then
        If y > 0 Then
            Atan2 = hPi
        ElseIf y < 0 Then
            Atan2 = -hPi
        Else
            Atan2 = 0
        End If
    ElseIf y = 0 Then
        If x < 0 Then
            Atan2 = Pi
        Else
            Atan2 = 0
        End If
    Else
        If x < 0 Then
            If y > 0 Then
                Atan2 = Atn(y / x) + Pi
            Else
                Atan2 = Atn(y / x) - Pi
            End If
        Else
            Atan2 = Atn(y / x)
        End If
    End If
    
End Function

'gives you the differense between two angles in radians
Function RadDiff(a As Double, b As Double) As Double

    Dim c As Double
    c = a - b
    Do
        If c < -Pi Then
            c = c + Rad360
        ElseIf c > Pi Then
            c = c - Rad360
        End If
    Loop Until c >= -Pi And c <= Pi
    RadDiff = c
    
End Function

'let go!
Private Sub picB_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)

    If Button = 1 Then If (Player(0).ctrl And c_SHOOT) Then Player(0).ctrl = Player(0).ctrl Xor c_SHOOT 'oi, did i NOT hit anything? :\

End Sub

'need for speed
Private Sub srlSpeed_Change()

    tIndex = srlSpeed 'game speed controller! control urself! squirt

End Sub

Private Sub srlSpeed_GotFocus()

    picB.SetFocus

End Sub

Private Sub txtLimit_Change()

    txtLimit = Val(txtLimit) 'ah, the goal limit
    picB.SetFocus

End Sub
