defmodule Amrita.PostsTest do
  use Amrita.DataCase

  alias Amrita.Posts

  describe "notes" do
    alias Amrita.Posts.Note

    @valid_attrs %{id: "7488a646-e31f-11e4-aace-600308960662", message: "some message", userid: "some userid"}
    @update_attrs %{id: "7488a646-e31f-11e4-aace-600308960668", message: "some updated message", userid: "some updated userid"}
    @invalid_attrs %{id: nil, message: nil, userid: nil}

    def note_fixture(attrs \\ %{}) do
      {:ok, note} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_note()

      note
    end

    test "list_notes/0 returns all notes" do
      note = note_fixture()
      assert Posts.list_notes() == [note]
    end

    test "get_note!/1 returns the note with given id" do
      note = note_fixture()
      assert Posts.get_note!(note.id) == note
    end

    test "create_note/1 with valid data creates a note" do
      assert {:ok, %Note{} = note} = Posts.create_note(@valid_attrs)
      assert note.id == "7488a646-e31f-11e4-aace-600308960662"
      assert note.message == "some message"
      assert note.userid == "some userid"
    end

    test "create_note/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_note(@invalid_attrs)
    end

    test "update_note/2 with valid data updates the note" do
      note = note_fixture()
      assert {:ok, %Note{} = note} = Posts.update_note(note, @update_attrs)
      assert note.id == "7488a646-e31f-11e4-aace-600308960668"
      assert note.message == "some updated message"
      assert note.userid == "some updated userid"
    end

    test "update_note/2 with invalid data returns error changeset" do
      note = note_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_note(note, @invalid_attrs)
      assert note == Posts.get_note!(note.id)
    end

    test "delete_note/1 deletes the note" do
      note = note_fixture()
      assert {:ok, %Note{}} = Posts.delete_note(note)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_note!(note.id) end
    end

    test "change_note/1 returns a note changeset" do
      note = note_fixture()
      assert %Ecto.Changeset{} = Posts.change_note(note)
    end
  end
end
