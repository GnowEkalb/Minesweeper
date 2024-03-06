import de.bezier.guido.*;
public static final int NUM_ROWS = 16;
public static final int NUM_COLS = 16;
public static final int NUM_MINES = 30;
private MSButton[][] buttons; 
private ArrayList <MSButton> mines = new ArrayList <MSButton>();
void setup ()
{
    size(800, 800);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    //your code to initialize buttons goes here
    for (int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    
    setMines();
}
public void setMines()
{
    while(mines.size() < NUM_MINES){
        int r = (int)(Math.random()* NUM_ROWS);
        int c = (int)(Math.random()* NUM_COLS);
        if (!mines.contains(buttons[r][c])){
          mines.add(buttons[r][c]);
        }
    }
}

public void draw ()
{
    background( 0 );
   
}
public boolean isWon()
{
    for (int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_COLS; c++){
        if(!mines.contains(buttons[r][c]) && !buttons[r][c].clicked)
          return false;
      }
    }
    return true;
}
public void displayLosingMessage()
{
    for (int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_COLS; c++){
        if(mines.contains(buttons[r][c]))
          buttons[r][c].clicked = true;
      }
    }
}
public void displayWinningMessage()
{
   for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {

          if (mines.contains(buttons[r][c])) {
              buttons[r][c].flagged = true; 
          }
          buttons[r][c].clicked = true; 
      }
   }
}
public boolean isValid(int r, int c)
{
  if (r >= NUM_ROWS || c >= NUM_COLS)
    return false;
  if (r < 0 || c < 0)
    return false;
  return true;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    
      for (int i = row-1; i <= row+1; i++)
  {
    for (int j = col-1; j <= col+1; j++)
    {
      if (isValid(i,j) && mines.contains(buttons[i][j]))
      numMines++;
    }
  }
  if (mines.contains(buttons[row][col]))
    numMines--;
  return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 800/NUM_COLS;
        height = 800/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); 
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
          flagged = !flagged;
          if(flagged == false)
            clicked = false;
        }
        else if (mines.contains(this)){
          displayLosingMessage();
        }
        else if (countMines(myRow,myCol) > 0 && !mines.contains(buttons[myRow][myCol])){
         setLabel(countMines(myRow,myCol));
        }
        else
          for (int c = myCol-1; c <= myCol+1; c++){
            for (int r = myRow-1; r <= myRow+1; r++){
               if (isValid(r, c)) {
                   if (!buttons[r][c].isFlagged() && !buttons[r][c].clicked) {
                   buttons[r][c].mousePressed();
                }
              }
            }
          }
    }
    public void draw () 
    {   if (isWon() && mines.contains(this))
            fill(0,230,0);
        else if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );
      
        rect(x, y, width, height);
        fill(0);
        if (myLabel.equals("1"))
          fill(0,0,255);
        if (myLabel.equals("2"))
          fill(#429546);
        if (myLabel.equals("3"))
          fill(#B90410);
        if (myLabel.equals("4"))
          fill(#05115F);
        if (myLabel.equals("5"))
          fill(#9A34B7);
        textSize(width/2);
        text(myLabel,x+width/2,y+height/2);
        if(isWon() == true){
          displayWinningMessage();
          textSize(72);
          fill(0);
          text("YOU WIN!", 400,400);
        }
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public String getLabel(){
      return myLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
