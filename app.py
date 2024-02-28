from langchain.llms import CTransformers
from langchain import PromptTemplate
from langchain.chains import RetrievalQA
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.vectorstores import FAISS
from langchain.document_loaders import PyPDFLoader, DirectoryLoader, TextLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from PyPDF2 import PdfReader
from glob import glob
import pickle


# download LLaMA2 7B, 13B and 70B
# wget ./../models/https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGML/resolve/main/llama-2-7b-chat.ggmlv3.q8_0.bin?download=true
# wget ./../models/https://huggingface.co/TheBloke/Llama-2-13B-chat-GGML/resolve/main/llama-2-13b-chat.ggmlv3.q8_0.bin?download=true
# wget ./../models/https://huggingface.co/TheBloke/Llama-2-70B-Chat-GGML/resolve/main/llama-2-70b-chat.ggmlv3.q5_K_M.bin?download=true


LLaMA_model = '/mnt/local/model/llama-2-13b-chat.ggmlv3.q8_0.bin'

def loading_LLM():
    llm = CTransformers(model=LLaMA_model,
                        model_type='llama',
                        config={'max_new_tokens': 512, 'temperature': 0})
    return llm


def load_prompt_for_document():
    template = """Use the provided context to answer the user's question. if you don't know answer then return "I don't know".
    Context: {context}
    Question: {question}
    Answer:
    """
    prompt = PromptTemplate(template=template, input_variables=['context', 'question'])
    return prompt 

def load_prompt_for_metadata():
    template = """Use the provided context to answer the user's question. if you don't know answer then return to answer".
    Context: {context}
    Question: {question}
    Answer:
    """
    prompt = PromptTemplate(template=template, input_variables=['context', 'question'])
    return prompt 

def load_prompt_for_FQL():

    template = """If the user ask for any of the above FQL queries, return the generated corresponding query from the database.".
    Context: {context}
    Question: {question}
    Answer:
    """

    prompt = PromptTemplate(template=template, input_variables=['context', 'question'])
    return prompt 


def vector_storage_by_index():
    embeddings = HuggingFaceEmbeddings(
        model_name="sentence-transformers/all-MiniLM-L6-v2",
        model_kwargs={'device': 'cpu'}) #TODO: change to GPU
    db = FAISS.load_local("faiss/FQL", embeddings)
    return db

def chain_QA():
    llm = loading_LLM()
    vdb = vector_storage_by_index()
    prompt = load_prompt_for_FQL()
    retriever = vdb.as_retriever(search_kwargs={'k': 2})
    chain_return = RetrievalQA.from_chain_type(llm=llm,
                                           chain_type='stuff',
                                           retriever=retriever,
                                           return_source_documents=True,
                                           chain_type_kwargs={'prompt': prompt})
    return chain_return

def response(query, chain_res):
    return chain_res({'query':query})['result']

chain_qa = chain_QA()

while True:
    user_input = input('\n\nUser (type "exit" to quit): ')
    if user_input.lower() == 'exit':
        break
    response = response(query=user_input, chain_res=chain_qa)
    print(f'\n\nAI: {response}')

