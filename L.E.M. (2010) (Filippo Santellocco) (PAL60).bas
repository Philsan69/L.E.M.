 rem L.E.M.
 rem Lunar Excursion Module
 rem by Filippo Santellocco
 rem copyright 2010
 
 set romsize 16k
 set tv ntsc
 set kernel_options pfcolors pfheights player1colors
 set smartbranching on

 rem Clears all variables 
 a = 0 : b = 0 : c = 0 : d = 0 : e = 0 : f = 0 : g = 0 : h = 0 : i = 0
 j = 0 : k = 0 : l = 0 : m = 0 : n = 0 : o = 0 : p = 0 : q = 0 : r = 0
 s = 0 : t = 0 : u = 0 : v = 0 : w = 0 : x = 0 : y = 0 : z = 0
  
 const fontstyle=8
 rem "8" instead of "RETROPUTER" to avoid compiler error
 
 dim plposx=player1x.b
 dim plposy=player1y.d

 dim plmovx=e.f
 dim plmovy=g.h

 dim fireposx=i.j
 dim fireposy=k.l

 dim astposx=player0x
 dim astposy=y

 dim fuel=m.n

 dim landings=s

 dim lems=v

 dim wait=z

 dim sc1=score
 dim sc2=score+1
 dim sc3=score+2

 dim hisc1=a
 dim hisc2=c

 drawscreen
 
 scorecolor=0

 COLUBK=0     
 CTRLPF=$31

 pfheights:
  8
  11
  11
  11
  23
  4
  4
  4
  4
  4
  4
end
 
 pfcolors:
 $00
 $00
 $00
 $00
 $0C
 $0C
 $0A
 $08
 $06
 $04
 $02
end

restart

 player0:
 %00000000
end

 fuel=248.0
 lems=3
 wait=0
 pfclear
 pfscorecolor=0
 bally=100
 landings=0

 if sc1>hisc1 then newhighscore
 if sc1<hisc1 then skiphighscore
 if sc2>hisc2 then newhighscore
 if sc2<hisc2 then skiphighscore

 goto skiphighscore

newhighscore

 hisc1=sc1:hisc2=sc2
  
skiphighscore
 
 sc1=hisc1:sc2=hisc2:sc3=0 

 goto titlescreen bank2

start

 AUDV0=0
 AUDV1=0

 scorecolor=10

 const pfscore=1
 pfscorecolor=100
 pfscore1=%10101000
 pfscore2=255
 score=0

 goto playground
 
main

 COLUP0=100

 gosub playercolor1
 gosub playershape
  
 plmovy=plmovy+0.01
 if plmovy=1 then plmovy=0.99
 fireposy=100.0
 AUDV0=0

 if fuel=0 then goto movement

 if joy0right then gosub right
 if joy0left then gosub left
 if joy0fire then gosub up
 
 if fuel=217 then pfscore2=127
 if fuel=186 then pfscore2=63
 if fuel=155 then pfscore2=31
 if fuel=124 then pfscore2=15
 if fuel=93 then pfscore2=7
 if fuel=62 then pfscore2=3
 if fuel=31 then pfscore2=1
 if fuel=0 then pfscore2=0

movement

 if g=0 && h>60 then scorecolor=100 else scorecolor=10
 
 plposx=plposx+plmovx
 if plposx<17 || plposx>138 then plposx=plposx-plmovx:plmovx=0.0
 plposy=plposy+plmovy
 if plposy<8 || plposy>88 then plposy=plposy-plmovy:plmovy=0.0

 missile0x=plposx+fireposx
 missile0y=plposy+fireposy

 gosub asteroid

 gosub pad
  
 if collision(ball,player1) then goto landed
 if collision(playfield,player1) then lems=lems-1:wait=0:goto crash
 if collision(player0,player1) then lems=lems-1:wait=0:goto crash

 drawscreen

 goto main

asteroid
 if landings<5 then return
 if q=1 then goto leftright
rightleft 
 w=w+1
 if w=1 then gosub asteroidshape1
 if w=20 then gosub asteroidshape2
 if w=40 then gosub asteroidshape3
 if w=60 then gosub asteroidshape4
 if w=79 then w=0
 astposx=astposx-1
 if astposx=17 then p=rand/8:q=1:w=0:astposy=p+20
 if landings<9 then astposy=35
 player0y=astposy
 return

leftright
 w=w+1
 if w=1 then gosub asteroidshape4
 if w=20 then gosub asteroidshape3
 if w=40 then gosub asteroidshape2
 if w=60 then gosub asteroidshape1
 if w=79 then w=0
 astposx=astposx+1
 if astposx=138 then p=rand/8:q=0:w=0:astposy=p+20
 if landings<9 then astposy=35
 player0y=astposy
 return

pad
 if r=1 then goto pad2
pad1
 ballx=ballx-1:r=1
 return
pad2
 ballx=ballx+1:r=2
 return

up
 plmovy=plmovy-0.02
 missile0height=0
 fireposx=4.0
 fireposy=1.0
 AUDC0=8:AUDF0=30:AUDV0=10
 fuel=fuel-0.5
 return

left
 plmovx=plmovx-0.01
 missile0height=0
 fireposx=8.0
 fireposy=-5.0
 AUDC0=8:AUDF0=20:AUDV0=10
 fuel=fuel-0.2
 return

right
 plmovx=plmovx+0.01
 missile0height=0
 fireposx=0.0
 fireposy=-5.0
 AUDC0=8:AUDF0=20:AUDV0=10
 fuel=fuel-0.2
 return

landed
 if g=0 && h>60 then wait=0:lems=lems-1:goto crash
 if r=1 then u=ballx-2:o=ballx+2
 if r=2 then u=ballx-3:o=ballx+1
 if player1x>u && player1x<o then wait=0:AUDV0=0:goto landedgood
 lems=lems-1 
 wait=0
 goto crash

landedgood
 missile0y=100
  
 COLUP0=100
 
 wait=wait+1
 
 if wait=20 then player1y=plposy-1
 if wait=60 then AUDC0=12:AUDF0=14:AUDV0=6:scorecolor=84
 if wait=90 then AUDF0=21:scorecolor=10
 if wait=120 then AUDF0=14:scorecolor=84
 if wait=150 then AUDF0=21:scorecolor=10
 if wait=180 then gosub score:AUDV0=0

 gosub asteroid

 gosub pad

 drawscreen

 if wait>254 then landings=landings+1:gosub lemsdisplay: goto playground

 goto landedgood
 
crash
 missile0y=100

 COLUP0=100
 
 wait=wait+1

 if wait=1 then AUDV0=0:gosub explosion1
 if wait=2 then AUDV0=14:AUDC0=8:AUDF0=15:gosub explosion2
 if wait=12 then AUDV0=12:gosub explosion3
 if wait=22 then AUDV0=10:gosub explosion4
 if wait=32 then AUDV0=8:gosub explosion5
 if wait=42 then AUDV0=6:gosub explosion6
 if wait=52 then AUDV0=5:gosub explosion7
 if wait=62 then AUDV0=4:gosub explosion8
 if wait=72 then AUDV0=3:gosub explosion1
 if wait=92 then AUDV0=2
 if wait=102 then AUDV0=1
 if wait=112 then AUDV0=0

 gosub asteroid

 gosub pad
 
 drawscreen

 if lems=0 && wait>254 then scorecolor=10:goto restart
 if lems>0 && wait>200 then goto playground
 
 goto crash
 
playground
 plposx=77.0
 plposy=8.0

 plmovx=0.0
 plmovy=0.0

 fireposx=0.0
 fireposy=0.0

 bally=100

 player0y=100

 p=rand/8
 astposy=p+20
 astposx=138

 fuel=248.0

 w=0
 
 pfclear
 
 scorecolor=10
 pfscore2=255
 
 gosub playercolor1

 p=rand/8
 if p>28 then p=27
 
 pfvline 0 6 10 on
 q=6
 for o=1 to p
 drawscreen
 temp5=rand
 if temp5>127 then q=q+1 
 if temp5<=127 then q=q-1
 if q<5 then q=5
 if q>10 then q=10
 pfvline o q 10 on
 next o

 t=p+1:u=p+2
 o=(t*4)+18:r=(q*4)+43
 pfvline t q 10 on
 pfvline u q 10 on
 ballx=o
 bally=r
 ballheight=0

 t=p+3
 for o=t to 31
 drawscreen
 p=rand
 if p>127 then q=q+1 
 if p<=127 then q=q-1
 if q<5 then q=5
 if q>10 then q=10
 pfvline o q 10 on
 next o

 q=0:r=0:u=0

 if lems=1 then pfscore1=%00000000
 if lems=2 then pfscore1=%10000000
 if lems=3 then pfscore1=%10100000
 if lems=4 then pfscore1=%10101000
 if lems=5 then pfscore1=%10101010

 goto main

score
 if fuel>217 then score=score+10000:return
 if fuel>186 then score=score+5000:return
 if fuel>155 then score=score+3000:return
 if fuel>124 then score=score+1000:return
 if fuel>93 then score=score+800:return
 if fuel>62 then score=score+600:return
 if fuel>31 then score=score+400:return
 if fuel>0 then score=score+200:return
 if fuel=0 then score=score+100:return

lemsdisplay
 if landings=3 then lems=lems+1:landings=4:wait=0:goto beep
 if landings=9 then lems=lems+1:landings=10:wait=0:goto beep
 return

beep
 wait=wait+1
 if wait=1 then AUDC0=4:AUDF0=16:AUDV0=10
 if wait=60 then AUDV0=0
 if lems=2 then pfscore1=%10000000
 if lems=3 then pfscore1=%10100000
 if lems=4 then pfscore1=%10101000
 if lems=5 then pfscore1=%10101010
 if wait=100 then return
 gosub asteroid
 gosub pad
 COLUP0=100
 drawscreen
 goto beep 

playershape
 player1:
 %10010010
 %10111010
 %01111100
 %00111000
 %01111100
 %01111100
 %00111000
 %00000000
end
 return

asteroidshape1
 player0:
 %00001110
 %01111111
 %11111011
 %11111111
 %10111111
 %11110110
 %01111110
 %00111100
end
 return

asteroidshape2
 player0:
 %01111000
 %11111110
 %11011111
 %11111011
 %01111111
 %01111111
 %01110110
 %00111100
end
 return

asteroidshape3
 player0:
 %00111100
 %01111110
 %01101111
 %11111101
 %11111111
 %11011111
 %11111110
 %01110000
end
 return
 
asteroidshape4
 player0:
 %00111100
 %01101110
 %11111110
 %11111110
 %11011111
 %11111011
 %01111111
 %00011110
end
 return

playercolor1
 AUDF0=12
 player1color:
 $28
 $28
 $26
 $04
 $06
 $08
 $0A
 $0C
end
 return

explosion1
 player1color:
 $2C
 $64
 $2C
 $64
 $64
 $2C
 $64
 $2C
end

 player1:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end
 return

explosion2
 player1:
 %00000000
 %00000000
 %00010000
 %00111000
 %00111000
 %00010000
 %00000000
 %00000000
end
 return

explosion3 
 player1:
 %00000000
 %00010000
 %01000100
 %00001000
 %10100000
 %01000100
 %00010000
 %00000000
end
 return

explosion4
 player1:
 %00001000
 %01000000
 %00000001
 %00010100
 %10101000
 %00000100
 %01000001
 %00001000
end
 return
 
explosion5
 player1:
 %10001000
 %00000001
 %00010100
 %00000001
 %10100000
 %00010100
 %00000001
 %10010100
end
 return
 
explosion6
 player1:
 %10001001
 %01010100
 %00000010
 %01000001
 %10000010
 %00100000
 %01001010
 %10010001
end
 return
 
explosion7
 player1:
 %01010010
 %00001000
 %00000001
 %10000010
 %00000000
 %01000000
 %00000001
 %01001000
end
 return

explosion8
 player1:
 %01000010
 %00000001
 %10000000
 %00000000
 %00000000
 %00000000
 %00000000
 %10000001
end
 return


 bank 2
 
titlescreen

 rem Music Starter using sdata
 rem Based on code posted in the Ballblazer thread at AtariAge:
 rem http://www.atariage.com/forums/index.php?s=&showtopic=130990&view=findpost&p=1615280
 rem Code adapted by Duane Alan Hahn (Random Terrain)
    
 AUDV0=0
 AUDV1=0

 p=1
 w=0: rem Plays music only one time
 goto MusicSetup

MainLoop

 CTRLPF=$31
 if joy0fire then goto start bank1

 goto GetMusic

GotMusic

 rem Titlescreen kernel by Mike Saarna (RevEng)
 rem http://www.atariage.com/forums/topic/169819-the-titlescreen-kernel/

 rem Titlescreen minikernels colors
 dim bmp_48x1_1_color=player0y
 dim bmp_48x1_2_color=player0x
 dim bmp_48x1_3_color=player1x

 bmp_48x1_1_color=100
 bmp_48x1_2_color=10
 bmp_48x1_3_color=84

 scorecolor=10
 if sc1=0 && sc2=0 && sc3=0 then scorecolor=0

 gosub titledrawscreen

 goto MainLoop

GetMusic

 if w=1 then goto GotMusic
 p=p-1
 if p>0 then GotMusic

 temp4=sread(musicData)
 temp5=sread(musicData)
 temp6=sread(musicData)

 if temp4=255 then p=1:w=1:goto MusicSetup

 AUDV0=temp4
 AUDC0=temp5
 AUDF0=temp6

 temp4=sread(musicData)
 temp5=sread(musicData)
 temp6=sread(musicData)

 AUDV1=temp4
 AUDC1=temp5
 AUDF1=temp6

 p=sread(musicData)
 goto GotMusic

 rem  *****************************************************
 rem  *  Music Data Block
 rem  *****************************************************
 rem  *  Format:
 rem  *  v,c,f (channel 0)
 rem  *  v,c,f (channel 1) 
 rem  *  d
 rem  *
 rem  *  Explanation:
 rem  *  v - volume (0 to 15)
 rem  *  c - control [a.k.a. tone, voice, and distortion] (0 to 15)
 rem  *  f - frequency (0 to 31)
 rem  *  d - duration

MusicSetup

 sdata musicData=x
 0,0,0
 0,0,0
 20

 0,0,0
 8,4,29
 12
 0,0,0
 2,4,29
 8

 8,4,23
 0,0,0
 12
 2,4,23
 0,0,0
 8

 8,4,19
 0,0,0
 12
 2,4,19
 0,0,0
 8

 8,4,23
 0,0,0
 12
 2,4,23
 0,0,0
 8

 8,4,17
 8,4,19
 32
 2,4,17
 8,4,19
 8

 8,4,19
 8,4,23
 12
 2,4,19
 8,4,23
 8

 8,4,23
 8,4,29
 12
 2,4,23
 8,4,29
 8

 0,0,0
 0,0,0
 20

 8,4,23
 8,4,29
 12
 2,4,23
 8,4,29
 8

 8,4,19
 0,0,0
 12
 2,4,19
 0,0,0
 8

 8,4,23
 0,0,0
 12
 2,4,23
 0,0,0
 8

 8,4,17
 0,0,0
 12
 2,4,17
 0,0,0
 8

 8,4,17
 0,0,0
 12
 2,4,17
 0,0,0
 8

 8,4,19
 0,0,0
 12
 2,4,19
 0,0,0
 8

 8,4,23
 0,0,0
 12
 2,4,23
 0,0,0
 8

 0,0,0
 8,4,31
 12
 0,0,0
 2,4,31
 8

 8,4,23
 0,0,0
 12
 2,4,23
 0,0,0
 8

 8,4,19
 0,0,0
 12
 2,4,19
 0,0,0
 8

 8,4,23
 0,0,0
 12
 2,4,23
 0,0,0
 8

 8,4,17
 8,4,23
 32
 2,4,17
 8,4,23
 8

 8,4,19
 8,4,23
 12
 2,4,19
 8,4,23
 8

 8,4,23
 8,4,31
 12
 2,4,23
 8,4,31
 8

 0,0,0
 0,0,0
 20

 8,4,23
 8,4,31
 12
 2,4,23
 8,4,31
 8

 8,4,19
 0,0,0
 12
 2,4,19
 0,0,0
 8

 8,4,23
 0,0,0
 12
 2,4,23
 0,0,0
 8

 8,4,14
 0,0,0
 12
 2,4,14
 0,0,0
 8

 8,4,14
 0,0,0
 12
 2,4,14
 0,0,0
 8

 8,4,15
 0,0,0
 12
 2,4,15
 0,0,0
 8

 8,4,19
 0,0,0
 12
 2,4,19
 0,0,0
 8

 0,0,0
 0,0,0
 20

 255,255,255
 255,255,255
 1
end

 goto GotMusic
 asm
 include "titlescreen/asm/titlescreen.asm"
end